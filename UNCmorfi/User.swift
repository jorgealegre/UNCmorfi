//
//  User.swift
//  UNCmorfi
//
//  Created by George Alegre on 4/25/17.
//  Copyright © 2017 George Alegre. All rights reserved.
//

import Foundation
import UIKit

class User {
    // MARK: Properties
    var name: String
    let code: String
    var balance: Int
    var image: UIImage?
    var imageCode: String
    
    init(code: String) {
        self.code = code
        self.name = ""
        self.balance = 0
        self.imageCode = ""
    }
    
    func update(callback: @escaping () -> ()) {
        getUserStatus(from: code) { error, name, balance, imageCode in
            self.name = name
            self.balance = balance
            self.imageCode = imageCode
            
            if self.image == nil {
                getUserImage(from: imageCode) { error, image in
                    self.image = image
                    
                    callback()
                }
            } else {
                callback()
            }
        }
    }
}
