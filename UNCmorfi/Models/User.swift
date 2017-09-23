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

    init(fromCode code: String) {
        self.code = code.uppercased()
        self.name = ""
        self.balance = 0
        self.imageCode = ""
        self.image = nil
    }
    
    // MARK: Methods
    func update(callback: (() -> ())? = nil) {
        UNCComedor.getUserStatus(from: code) { error, name, balance, imageCode in
            guard error == nil else {
                if let callback = callback {
                    callback()
                }
                return
            }
            
            if let name = name, let balance = balance, let imageCode = imageCode {
                self.name = name
                self.balance = balance
                self.imageCode = imageCode
                
                if self.image == nil {
                    UNCComedor.getUserImage(from: imageCode) { error, image in
                        guard error == nil else {
                            callback?()
                            return
                        }
                        
                        self.image = image

                        if let callback = callback {
                            callback()
                        }
                        return
                    }
                } else {
                    if let callback = callback {
                        callback()
                    }
                    return
                }
            } else {
                if let callback = callback {
                    callback()
                }
                return
            }
        }
    }

    // MARK: Codable
    private static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("users")

    private enum CodingKeys: String, CodingKey {
        case name
        case balance
        case code
        case imageCode
        
        // Image is gonna be encoded as data and an image will be obtained from this data when decoding.
        case image
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        balance = try values.decode(Int.self, forKey: .balance)
        code = try values.decode(String.self, forKey: .code)
        imageCode = try values.decode(String.self, forKey: .imageCode)

        if let imageData = try values.decodeIfPresent(Data.self, forKey: .image) {
            image = NSKeyedUnarchiver.unarchiveObject(with: imageData) as? UIImage
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

        if let image = image {
            let imageData = NSKeyedArchiver.archivedData(withRootObject: image)
            try container.encode(imageData, forKey: .image)
        }
    }
}

extension User: Equatable {
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.code == rhs.code
    }
}
