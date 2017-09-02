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

struct PropertyKey {
    static let name = "name"
    static let code = "code"
    static let balance = "balance"
    static let image = "image"
    static let imageCode = "imageCode"
}

class User: NSObject, NSCoding {
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
    func update(callback: @escaping () -> ()) {
        UNCComedor.getUserStatus(from: code) { error, name, balance, imageCode in
            guard error == nil else {
                callback()
                return
            }
            
            if let name = name, let balance = balance, let imageCode = imageCode {
                self.name = name
                self.balance = balance
                self.imageCode = imageCode
                
                if self.image == nil {
                    UNCComedor.getUserImage(from: imageCode) { error, image in
                        guard error == nil else {
                            callback()
                            return
                        }
                        
                        self.image = image

                        callback()
                    }
                } else {
                    callback()
                }
            } else {
                callback()
            }
        }
    }

    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("users")
    
    // MARK: NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        guard
            let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String,
            let code = aDecoder.decodeObject(forKey: PropertyKey.code) as? String,
            let imageCode = aDecoder.decodeObject(forKey: PropertyKey.imageCode) as? String
        else {
            if #available(iOS 10.0, *) {
                os_log("Unable to decode User data.", log: .default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
            return nil
        }

        let balance = aDecoder.decodeInteger(forKey: PropertyKey.balance)
        let image = aDecoder.decodeObject(forKey: PropertyKey.image) as? UIImage
        
        // Must call designated initializer.
        self.init(fromCode: code)
        self.image = image
        self.imageCode = imageCode
        self.balance = balance
        self.name = name
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(code, forKey: PropertyKey.code)
        aCoder.encode(balance, forKey: PropertyKey.balance)
        aCoder.encode(image, forKey: PropertyKey.image)
        aCoder.encode(imageCode, forKey: PropertyKey.imageCode)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let user = object as? User {
            return code == user.code
        }
        
        return false
    }
}
