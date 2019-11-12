//
//  User.swift
//  UNCmorfi
//
//  Created by George Alegre on 4/25/17.
//
//  LICENSE is at the root of this project's repository.
//

import Foundation
import UIKit
import os.log

class User: Codable {
    // MARK: Properties
    var name: String
    let code: String
    var balance: Int
    var image: UIImage?
    var imageCode: String
    var imageURL: URL? // TODO this should change
    var expirationDate: Date

    // TODO we should not need this initializer like this, only to store the user code.
    init(fromCode code: String) {
        self.code = code.uppercased()
        self.name = ""
        self.balance = 0
        self.imageCode = ""
        self.image = nil
        self.expirationDate = Date()
        self.imageURL = nil
    }
    
    // MARK: Codable

    private enum CodingKeys: String, CodingKey {
        case name
        case balance
        case code
        case imageCode
        case expirationDate
        case imageURL

        // Image is gonna be encoded as data and an image will be obtained from this data when decoding.
        case image
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        balance = try values.decode(Int.self, forKey: .balance)
        code = try values.decode(String.self, forKey: .code)
        imageCode = try values.decode(String.self, forKey: .imageCode)
        expirationDate = try values.decode(Date.self, forKey: .expirationDate)
        imageURL = try values.decode(URL.self, forKey: .imageURL)

        if let imageBase64 = try values.decodeIfPresent(String.self, forKey: .image),
            let imageData = Data(base64Encoded: imageBase64) {
            image = UIImage(data: imageData)
        } else {
            image = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(balance, forKey: .balance)
        try container.encode(code, forKey: .code)
        try container.encode(imageCode, forKey: .imageCode)
        try container.encode(expirationDate, forKey: .expirationDate)
        try container.encode(imageURL, forKey: .imageURL)

        if let image = image,
            let imageData = image.pngData() {
            try container.encode(imageData.base64EncodedString(), forKey: .image)
        }
    }
}

extension User: Equatable {
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.code == rhs.code
    }
}

extension Array where Element == User {
    func matchingOrder(of users: [Element]) throws -> [Element] {
        let result: [Element]
        
        result = users.compactMap { (user) -> Element? in
            guard let index = self.firstIndex(of: user) else {
                return nil
            }
            
            return self[index]
        }
        
        if result.count != self.count {
            throw NSError()
        }
        
        return result
    }
}
