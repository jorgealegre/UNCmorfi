import Foundation

public struct Servings: Codable {
    public let servings: [String: Int]

    public init(servings: [String: Int]) {
        self.servings = servings
    }
}
