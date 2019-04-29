//
// Copyright © 2018 George Alegre. All rights reserved.
//

import Foundation

struct Menu: Codable {
    let menu: [Date: [String]]

    private enum CodingKeys: CodingKey {
        case menu
    }

    // This is needed because of a bug in Swift: https://bugs.swift.org/browse/SR-7788
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let menuData = try container.decode([String: [String]].self, forKey: .menu)

        let dateFormatter = ISO8601DateFormatter()

        var menu: [Date: [String]] = [:]
        for (key, value) in menuData {
            let date = dateFormatter.date(from: key)!
            menu[date] = value
        }

        self.menu = menu
    }
}
