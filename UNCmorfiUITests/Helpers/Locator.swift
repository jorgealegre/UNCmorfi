//
// Copyright © 2019 George Alegre. All rights reserved.
//

import XCTest

protocol Locator: CustomStringConvertible {}

extension Locator where Self: RawRepresentable, Self.RawValue == String {
    var description: String { rawValue }
}

extension XCUIElementQuery {
    subscript(locator: Locator) -> XCUIElement { self[locator.description] }
}
