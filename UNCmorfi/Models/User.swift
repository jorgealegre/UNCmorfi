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
//    var expiryDate: Date

    init(fromCode code: String) {
        self.code = code.uppercased()
        self.name = ""
        self.balance = 0
        self.imageCode = ""
        self.image = nil
//        self.expiryDate = Date()
    }
    
    // MARK: Codable
    private static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("users")

    private enum CodingKeys: String, CodingKey {
        case name
        case balance
        case code
        case imageCode
        case expiryDate

        // Image is gonna be encoded as data and an image will be obtained from this data when decoding.
        case image
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        balance = try values.decode(Int.self, forKey: .balance)
        code = try values.decode(String.self, forKey: .code)
        imageCode = try values.decode(String.self, forKey: .imageCode)
//        expiryDate = try values.decode(Date.self, forKey: .expiryDate)

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
//        try container.encode(expiryDate, forKey: .expiryDate)

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
    
    /**
     Updates a collection of users.
     - Parameter callback: handler to be called with updated users as argument.
     */
    func update(callback: @escaping (([User]) -> Void)) {
        // Create a queue for parallel jobs.
        let queue = DispatchQueue.global(qos: .userInitiated)
        let group = DispatchGroup()

        // Return the original data if the update fails.
        let backup: [User] = self
        var updateFailed = false
        
        var result: [User] = []
        var images: [String: UIImage] = [:]

        // Get the user codes needed for the user API.
        let userCodes = map { $0.code }
        
        // Get the updated users from the API.
        group.enter()
        UNCComedor.api.getUsers(from: userCodes) { (apiResult) in
            // Notify that this task is done.
            defer { group.leave() }
            
            switch apiResult {
            case .failure(let error):
                // TODO: handle error
                updateFailed = true
                return
            case .success(let users):
                result = users
                
                // Get the updated user images from the API.
                users.forEach { (user) in
                    group.enter()
                    
                    UNCComedor.api.getUserImage(from: user.imageCode) { imageResult in
                        // Notify that this task is done.
                        defer { group.leave() }
                        
                        switch imageResult {
                        case .failure(_):
                            // TODO: handle error
                            updateFailed = true
                            return
                        case .success(let image):
                            user.image = image
                        }
                    }
                }
            }
        }
        
        // When all tasks have finished.
        group.notify(queue: queue) {
            if updateFailed {
                callback(backup)
            } else {
                callback((try? result.matchingOrder(of: self)) ?? backup)
            }
        }
    }
}
