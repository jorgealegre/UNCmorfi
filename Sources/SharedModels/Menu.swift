import Foundation

public struct Menu: Codable {
    public let menu: [String: [String]]

    public init(menu: [String : [String]]) {
        self.menu = menu
    }
}
