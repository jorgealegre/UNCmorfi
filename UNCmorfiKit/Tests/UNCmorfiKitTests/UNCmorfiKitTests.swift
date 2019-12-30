//
// Copyright © 2019 George Alegre. All rights reserved.
//

import XCTest
@testable import UNCmorfiKit

final class UNCmorfiKitTests: XCTestCase {
    func testValidMenuJSONDecoding() throws {
        
        let menuJSONData = """
            {
                "menu": {
                    "2019-12-09T00:00:00Z": [
                        "Milanesa al roquefort",
                        "Ensalada",
                        "Fruta de estación"
                    ],
                }
            }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()

        XCTAssertNoThrow(try decoder.decode(Menu.self, from: menuJSONData))
    }

    func testValidServingsJSONDecoding() throws {

        let jsonData = """
            {
                "servings": {
                    "2019-12-09T00:00:00Z": 12,
                }
            }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()

        XCTAssertNoThrow(try decoder.decode(Servings.self, from: jsonData))
    }

    func testUsersMatchingOrder() throws {
        let users = [
            User(name: "Jorge", code: "123", balance: 123, imageURL: nil, expirationDate: Date(), type: "Type"),
            User(name: "Alegre", code: "123", balance: 123, imageURL: nil, expirationDate: Date(), type: "Type")
        ]

        XCTAssertEqual(users, try users.reversed().matchingOrder(of: users))
    }

    func testUsersNotMatchingOrder() throws {
        let users = [
            User(name: "Jorge", code: "123", balance: 123, imageURL: nil, expirationDate: Date(), type: "Type"),
            User(name: "Alegre", code: "123", balance: 123, imageURL: nil, expirationDate: Date(), type: "Type")
        ]

        XCTAssertThrowsError(try users.matchingOrder(of: users.dropLast()))
    }
}
