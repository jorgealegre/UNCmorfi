//
//  UNCComedor.swift
//  UNCmorfi
//
//  Created by George Alegre on 4/23/17.
//
//  LICENSE is at the root of this project's repository.
//

import Foundation

class UNCComedor {

    // MARK: - Singleton

    static let shared = UNCComedor()

    private init() {
    }
    
    // MARK: - Properties

    private let session = URLSession.shared

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    // MARK: - API endpoints

    private static let baseURL = URL(string: "https://uncmorfi.georgealegre.com/")!

    // MARK: Helpers
    
    /**
     Use as first error handling method of any type of URLSession task.
     - Parameters:
     - error: an optional error found in the task completion handler.
     - res: the `URLResponse` found in the task completion handler.
     - Returns: if an error is found, a custom error is returned, else `nil`.
     */
    private func handleAPIResponse(error: Error?, res: URLResponse?) -> Error? {
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
    
    func getUsers(from codes: [String], callback: @escaping (_ result: Result<[User], Error>) -> Void) {
        guard !codes.isEmpty else {
            callback(.success([]))
            return
        }
        
        // Prepare the request and its parameters.
        var request = URLComponents(string: UNCComedor.baseURL.appendingPathComponent("users").absoluteString)!
        request.queryItems = [URLQueryItem(name: "codes", value: codes.joined(separator: ","))]
        
        // Send the request and setup the callback.
        let task  = session.dataTask(with: request.url!) { data, res, error in
            // Check for errors and exit early.
            let customError = self.handleAPIResponse(error: error, res: res)
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
            let users: [User]
            do {
                users = try self.decoder.decode([User].self, from: data)
            } catch {
                callback(.failure(NSError()))
                return
            }

            callback(.success(users))
        }
        
        task.resume()
    }
    
    func getMenu(callback: @escaping (_ result: Result<Menu, Error>) -> Void) {
        let task = session.dataTask(with: UNCComedor.baseURL.appendingPathComponent("menu")) { data, res, error in
            // Check for errors and exit early.
            let customError = self.handleAPIResponse(error: error, res: res)
            guard customError == nil else {
                callback(.failure(customError!))
                return
            }
            
            guard let data = data else {
                callback(.failure(NSError()))
                // TODO create my own errors
                return
            }

            let menu: Menu
            do {
                menu = try self.decoder.decode(Menu.self, from: data)
            } catch {
                callback(.failure(NSError()))
                return
            }

            callback(.success(menu))
        }
        
        task.resume()
    }
    
    func getServings(callback: @escaping (_ result: Result<Servings, Error>) -> Void) {
        let task: URLSessionDataTask = session.dataTask(with: UNCComedor.baseURL.appendingPathComponent("servings")) { data, res, error in
            // Check for errors and exit early.
            let customError = self.handleAPIResponse(error: error, res: res)
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
            let servings: Servings
            do {
                servings = try self.decoder.decode(Servings.self, from: data)
            } catch {
                callback(.failure(NSError()))
                return
            }

            callback(.success(servings))
        }
        
        task.resume()
    }
}
