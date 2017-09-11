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

import Kanna

struct UNCComedor {
    static private let baseImageURL = URL(string: "https://asiruws.unc.edu.ar/foto/")!
    static private let baseDataURL = URL(string: "http://comedor.unc.edu.ar/gv-ds.php")!
    static private let baseMenuURL = URL(string: "https://www.unc.edu.ar/vida-estudiantil/men%C3%BA-de-la-semana")!
    static private let baseServingsURL = URL(string: "http://comedor.unc.edu.ar/comedor/1.0/gv-ds.php?accion=1&sede=0475&tqx=reqId:0")!

    static func getUserStatus(from code: String, callback: @escaping (_ error: Error?, _ name: String?, _ balance: Int?, _ image: String?) -> ()) {
        var request = URLRequest(url: baseDataURL)
        request.httpMethod = "POST"
        
        let requestData = "accion=4&responseHandler=''&codigo=\(code)"
        request.httpBody = requestData.data(using: .utf8)
        
        URLSession(configuration: .default).dataTask(with: request) { data, res, error in
            guard let data = data, error == nil else {
                callback(error, nil, nil, nil)
                return
            }
            
            if let status = res as? HTTPURLResponse, status.statusCode != 200 {
                print("statusCode should be 200, but is \(status.statusCode)")
                print("response = \(res!)")
                callback(error, nil, nil, nil)
                return
            }
            
            let response = String(data: data, encoding: .utf8)!
            
            let preffix = "rows: [{c: ["
            let suffix = "]}]}});"
            let preffixIndex = response.range(of: preffix)!.upperBound
            let suffixIndex = response.range(of: suffix)!.lowerBound
            
            let components = response[preffixIndex..<suffixIndex].components(separatedBy: "},{")
            
            var _16 = components[16]
            _16 = _16[_16.index(_16.startIndex, offsetBy: 4)..._16.index(_16.startIndex, offsetBy: _16.characters.count - 2)]
            
            var _17 = components[17]
            _17 = _17[_17.index(_17.startIndex, offsetBy: 4)..._17.index(_17.startIndex, offsetBy: _17.characters.count - 2)]
            
            var _5 = components[5]
            _5 = _5[_5.index(_5.startIndex, offsetBy: 3)..._5.index(_5.startIndex, offsetBy: _5.characters.count - 1)]
            
            var _24 = components[24]
            _24 = _24[_24.index(_24.startIndex, offsetBy: 4)..._24.index(_24.startIndex, offsetBy: _24.characters.count - 2)]
            
            let name = "\(_16) \(_17)"
            let balance = Int(_5)!
            let image = _24
            
            callback(nil, name, balance, image)
        }.resume()
    }

    static func getUserImage(from code: String, callback: @escaping (_ error: Error?, _ image: UIImage?) -> ()) {
        URLSession(configuration: .default).dataTask(with: baseImageURL.appendingPathComponent(code)) { data, res, error in
            guard let data = data, error == nil else {
                print("error: \(error!)")
                callback(error, nil)
                return
            }
            
            if let status = res as? HTTPURLResponse, status.statusCode != 200 {
                print("statusCode should be 200, but is \(status.statusCode)")
                print("response = \(res!)")
                callback(error, nil)
                return
            }
            
            let image = UIImage(data: data)!
            
            callback(nil, image)
        }.resume()
    }
    
    static func getMenu(callback: @escaping (_ error: Error?, _ menu: [Date:[String]]?) -> ()) {
        URLSession(configuration: .default).dataTask(with: baseMenuURL) { data, res, error in
            guard let data = data, error == nil else {
                print("error: \(error!)")
                callback(error, nil)
                return
            }
            
            if let status = res as? HTTPURLResponse, status.statusCode != 200 {
                print("statusCode should be 200, but is \(status.statusCode)")
                print("response = \(res!)")
                callback(error, nil)
                return
            }
            
            let response = String(data: data, encoding: .utf8)!
            
            // Try to parse HTML
            guard let doc = HTML(html: response, encoding: .utf8) else {
                print("can't parse HTML response.")
                // TODO(alegre): should create error
                callback(NSError(), nil)
                return
            }
            
            // Should handle parsing lightly, don't completely know server's behaviour.
            // Prefer to not show anything or parse wrongly than to crash.
            var menu: [Date:[String]] = [:]

            let monday = Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
            
            
            for (index, XMLElement) in doc.xpath("//div[@class='field-item even']/ul").enumerated() {
                let foodList = (XMLElement.text?.components(separatedBy: "\n") ?? []).filter {!$0.isEmpty}
                let day = monday.addingTimeInterval(TimeInterval(index * 24 * 60 * 60))
                menu[day] = foodList
            }
        
            callback(nil, menu)
        }.resume()
    }

    static func getServings(callback: @escaping (_ error: Error?, _ servings: [Date: Int]?) -> ()) {
        URLSession(configuration: .default).dataTask(with: baseServingsURL) { (data, res, error) in
            guard let data = data, error == nil else {
                print("error: \(error!)")
                callback(error, nil)
                return
            }

            guard let status = res as? HTTPURLResponse, status.statusCode == 200 else {
                print("statusCode should be 200.")
                callback(error, nil)
                return
            }

            guard let response = String(data: data, encoding: .utf8) else {
                print("Error decoding response as UTF-8 string.")
                callback(nil, nil)
                return
            }

            /* Server response is weird Javascript function application with data as function's parameter.
             * Data is not a JSON string but a Javascript object, not to be confused with one another.
             */

            // Attempt to parse string into something useful.
            guard
                let start = response.range(of: "(")?.upperBound,
                let end = response.range(of: ")")?.lowerBound else {
                    callback(nil, nil)
                    return
            }
            var jsonString = response[start..<end]

            jsonString = jsonString
                // Add quotes to keys.
                .replacingOccurrences(of: "(\\w*[A-Za-z]\\w*)\\s*:",
                                      with: "\"$1\":",
                                      options: .regularExpression,
                                      range: jsonString.startIndex..<jsonString.endIndex)
                // Replace single quotes with double quotes.
                .replacingOccurrences(of: "'", with: "\"")

            // Parse fixed string.
            guard let jsonData = jsonString.data(using: .utf8) else {
                callback(nil, nil)
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
                callback(nil, nil)
                return
            }

            // Transform complicated JSON structure into simple [Date: Int] dictionary.
            guard let table = json?["table"] as? [String: [[String: Any]]] else {
                callback(nil, nil)
                return
            }

            guard let rows = table["rows"] else {
                callback(nil, nil)
                return
            }

            let result = rows.reduce([Date: Int]()) { (result, row) -> [Date: Int] in
                // 'result' parameter is constant, can't be changed.
                var result = result

                guard let row = row["c"] as? [[String: Any]] else {
                    return result
                }

                // The server only gave us a time in timezone GMT-3 (e.g. 12:09:00)
                // We need to add the current date and timezone data. (e.g. 2017-09-10 15:09:00 +0000)
                // Start off by getting the current date.
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'"

                let todaysDate = dateFormatter.string(from: Date())

                // Join today's date, the time from the row and the timezone into one string in ISO format.
                guard let time = row[0]["v"] as? String else {
                    return result
                }
                let dateString = "\(todaysDate)\(time)-0300"
                
                // Add time and timezone support to the parser.
                let timeFormat = "HH:mm:ssZ"
                dateFormatter.dateFormat = dateFormatter.dateFormat + timeFormat
                
                // Get a Date object from the resulting string.
                guard let date = dateFormatter.date(from: dateString) else {
                    return result
                }
                
                // Get food count from row.
                guard let count = row[1]["v"] as? Int else {
                    return result
                }
                
                // Add data to the dictionary.
                result[date] = count
                
                return result
            }

            callback(nil, result)
        }.resume()
    }
}
