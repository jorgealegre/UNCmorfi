//
// Copyright © 2019 George Alegre. All rights reserved.
//

import XCTest

class UsersPage: Page {
    @discardableResult
    func user(at index: Int) -> UserUIElement {
        UserUIElement(app.tables.cells.element(boundBy: index))
    }
}

class UserUIElement {

    enum Element: String, Locator {
        case photo = "user-photo"
        case name = "user-name"
        case barcode = "user-barcode"
        case balance = "user-balance"
    }

    private let uiElement: XCUIElement

    init(_ uiElement: XCUIElement) {
        self.uiElement = uiElement
    }

    func get(_ element: Element, callback: ((String) -> Void)? = nil) {
        callback?(uiElement.staticTexts[element].label)
    }
}
