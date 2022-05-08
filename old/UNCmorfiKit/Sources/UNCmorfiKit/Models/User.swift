//
// Copyright © 2019 George Alegre. All rights reserved.
//

import Foundation

public class User: Codable {
    public let name: String
    public let code: String
    public let balance: Int
    public let imageURL: URL?
    public let expirationDate: Date
    public let type: String

    public init(name: String, code: String, balance: Int, imageURL: URL?, expirationDate: Date, type: String) {
        self.name = name
        self.code = code
        self.balance = balance
        self.imageURL = imageURL
        self.expirationDate = expirationDate
        self.type = type
    }
}

extension User: Equatable {
    public static func ==(lhs: User, rhs: User) -> Bool {
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

extension User: Identifiable {
    public var id: String { code }
}
