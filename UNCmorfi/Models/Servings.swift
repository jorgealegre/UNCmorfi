//
// Copyright © 2018 George Alegre. All rights reserved.
//

import Foundation

struct Servings: Codable {
    let servings: [Date: Int]

    private enum CodingKeys: CodingKey {
        case servings
    }

    // This is needed because of a bug in Swift: https://bugs.swift.org/browse/SR-7788
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let data = try container.decode([String: Int].self, forKey: .servings)

        let dateFormatter = ISO8601DateFormatter()

        var servings: [Date: Int] = [:]
        for (key, value) in data {
            let date = dateFormatter.date(from: key)!
            servings[date] = value
        }

        self.servings = servings
    }
}
