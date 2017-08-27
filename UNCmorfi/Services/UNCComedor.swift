//
//  UNCComedor.swift
//  UNCmorfi
//
//  Created by George Alegre on 4/23/17.
//  Copyright © 2017 George Alegre. All rights reserved.
//

import Foundation
import UIKit

import Kanna

struct UNCComedor {
    static private let baseImageURL = URL(string: "https://asiruws.unc.edu.ar/foto/")!
    static private let baseDataURL = URL(string: "http://comedor.unc.edu.ar/gv-ds.php")!
    static private let baseMenuURL = URL(string: "https://www.unc.edu.ar/vida-estudiantil/men%C3%BA-de-la-semana")!

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
        let request = URLRequest(url: baseImageURL.appendingPathComponent(code))
        
        URLSession(configuration: .default).dataTask(with: request) { data, res, error in
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
        let request = URLRequest(url: baseMenuURL)

        URLSession(configuration: .default).dataTask(with: request) { data, res, error in
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
}
