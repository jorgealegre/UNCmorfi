//
//  UNCComedor.swift
//  UNCmorfi
//
//  Created by George Alegre on 4/23/17.
//
//  LICENSE is at the root of this project's repository.
//

import Foundation
import UIKit

import SwiftSoup

public enum Result<A> {
    case success(A)
    case failure(Error)
}

public final class UNCComedor {
    // MARK: Singleton
    public static let api = UNCComedor()
    private init() {}
    
    // MARK: URLSession
    private let session = URLSession.shared
    
    // MARK: API endpoints
    private static let baseImageURL = URL(string: "https://asiruws.unc.edu.ar/foto/")!
    private static let baseDataURL = "http://comedor.unc.edu.ar/gv-ds_test.php"
    private static let baseMenuURL = URL(string: "https://www.unc.edu.ar/vida-estudiantil/men%C3%BA-de-la-semana")!
    private static let baseServingsURL = URL(string: "http://comedor.unc.edu.ar/gv-ds_test.php?json=true&accion=1&sede=0475")!
    
    // MARK: Errors
    public enum UNCComedorError: Error {
        case servingDateUnparseable
        case servingCountUnparseable
    }
    
    // MARK: Response data wrappers
    private struct UserData: Decodable {
        let saldo: String
        let nombre: String
        let apellido: String
        let foto: String
        let codigo: String
        let fecha_hasta: Date
    }
    
    private struct Serving: Decodable {
        let count: Int
        let date: Date
        
        private enum CodingKeys: String, CodingKey {
            case count = "raciones"
            case date = "fecha"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let countString = try container.decode(String.self, forKey: .count)
            guard let count = Int(countString) else {
                throw UNCComedorError.servingCountUnparseable
            }
            self.count = count
            
            // The server only gave us a time in timezone GMT-3 (e.g. 12:09:00)
            // We need to add the current date and timezone data. (e.g. 2017-09-10 15:09:00 +0000)
            // Start off by getting the current date.
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'"
            
            let todaysDate = dateFormatter.string(from: Date())
            
            // Join today's date, the time and the timezone into one string in ISO format.
            let timeString = try container.decode(String.self, forKey: .date)
            let timestamp = "\(todaysDate)\(timeString)-0300"
            
            dateFormatter.dateFormat.append("HH:mm:ssZ")
            
            guard let date = dateFormatter.date(from: timestamp) else {
                throw UNCComedorError.servingDateUnparseable
            }
            
            self.date = date
        }
    }
    
    // MARK: Helpers
    
    /**
     Use as first error handling method of any type of URLSession task.
     - Parameters:
        - error: an optional error found in the task completion handler.
        - res: the `URLResponse` found in the task completion handler.
     - Returns: if an error is found, a custom error is returned, else `nil`.
     */
    private static func handleAPIResponse(error: Error?, res: URLResponse?) -> Error? {
        guard error == nil else {
            // TODO handle client error
            //            handleClientError(error)
            return error!
        }
        
        guard let httpResponse = res as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
                print("response = \(res!)")
                // TODO: create my own errors
                //            handleServerError(res)
                return NSError()
        }
        
        return nil
    }
    
    // MARK: - Public API methods
    func getUsers(from codes: [String], callback: @escaping (_ result: Result<[User]>) -> Void) {
        guard !codes.isEmpty else {
            callback(.success([]))
            return
        }
        
        // Prepare the request and its parameters.
        var request = URLComponents(string: UNCComedor.baseDataURL)!
        request.queryItems = [
            URLQueryItem(name: "json", value: "true"),
            URLQueryItem(name: "accion", value: "4"),
            URLQueryItem(name: "codigo", value: codes.joined(separator: ","))
        ]
        
        // Send the request and setup the callback.
        let task  = session.dataTask(with: request.url!) { data, res, error in
            // Check for errors and exit early.
            let customError = UNCComedor.handleAPIResponse(error: error, res: res)
            guard customError == nil else {
                callback(.failure(customError!))
                return
            }
            
            guard let data = data else {
                callback(.failure(NSError()))
                // TODO: create my own errors
                return
            }
            
            // Decode data.
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let userData: [UserData]
            do {
                userData = try decoder.decode([UserData].self, from: data)
            } catch {
                callback(.failure(NSError()))
                return
            }
            
            let users = userData.map { (userData: UserData) -> User in
                let user = User(fromCode: userData.codigo)
                user.balance = Int(userData.saldo) ?? 0
                user.imageCode = userData.foto
                user.name = "\(userData.nombre) \(userData.apellido)"
                user.expiryDate = userData.fecha_hasta
                
                return user
            }
            
            callback(.success(users))
        }
        
        task.resume()
    }
    
    func getUserImage(from code: String, callback: @escaping (_ result: Result<UIImage>) -> Void) {
        let url = UNCComedor.baseImageURL.appendingPathComponent(code)
        let task = session.dataTask(with: url) { data, res, error in
            // Check for errors and exit early.
            let customError = UNCComedor.handleAPIResponse(error: error, res: res)
            guard customError == nil else {
                callback(.failure(customError!))
                return
            }
            
            guard let data = data else {
                callback(.failure(NSError()))
                // TODO create my own errors
                return
            }
            
            guard let image = UIImage(data: data) else {
                callback(.failure(NSError()))
                return
            }
            
            callback(.success(image))
        }
        
        task.resume()
    }
    
    func getMenu(callback: @escaping (_ result: Result<[Date:[String]]>) -> Void) {
        let task = session.dataTask(with: UNCComedor.baseMenuURL) { data, res, error in
            // Check for errors and exit early.
            let customError = UNCComedor.handleAPIResponse(error: error, res: res)
            guard customError == nil else {
                callback(.failure(customError!))
                return
            }
            
            guard let data = data,
                let dataString = String(data: data, encoding: .utf8) else {
                    callback(.failure(NSError()))
                    // TODO create my own errors
                    return
            }
            
            // Try to parse HTML and find the elements we care about.
            let elements: Elements
            do {
                let doc = try SwiftSoup.parse(dataString)
                elements = try doc.select("div[class='field-item even']").select("ul")
            } catch {
                print("can't parse HTML response.")
                // TODO: should create error
                callback(.failure(NSError()))
                return
            }
            
            // Should handle parsing lightly, don't completely know server's behaviour.
            // Prefer to not show anything or parse wrongly than to crash.
            var menu: [Date: [String]] = [:]
            
            // Whatever week we're in, find monday.
            var startingDay = Calendar(identifier: .iso8601)
                    .date(from: Calendar(identifier: .iso8601)
                    .dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
            
            // For each day, parse the menu.
            do {
                for (index, element) in elements.enumerated() {
                    let listItems: [Element] = try element.select("li").array()
                    
                    let foodList = listItems
                        .compactMap { try? $0.text() }
                        .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                    
                    let day = startingDay.addingTimeInterval(TimeInterval(index * 24 * 60 * 60))
                    menu[day] = foodList
                }
            } catch {
                callback(.failure(NSError()))
                return
            }
            
            callback(.success(menu))
        }
        
        task.resume()
    }
    
    func getServings(callback: @escaping (_ result: Result<[Date: Int]>) -> Void) {
        let task: URLSessionDataTask = session.dataTask(with: UNCComedor.baseServingsURL) { data, res, error in
            // Check for errors and exit early.
            let customError = UNCComedor.handleAPIResponse(error: error, res: res)
            guard customError == nil else {
                callback(.failure(customError!))
                return
            }
            
            guard let data = data else {
                callback(.failure(NSError()))
                // TODO create my own errors
                return
            }
            
            // Parse received data.
            let servingData: [Serving]
            do {
                servingData = try JSONDecoder().decode([Serving].self, from: data)
            } catch UNCComedorError.servingDateUnparseable {
                callback(.failure(UNCComedorError.servingDateUnparseable))
                return
            } catch {
                callback(.failure(NSError()))
                return
            }
            
            // Transform data into expected output type.
            let servings = servingData.reduce(into: [Date: Int]()) { ( result: inout [Date: Int], serving) in
                result[serving.date, default: 0] += serving.count
            }
            
            callback(.success(servings))
        }
        
        task.resume()
    }
}
