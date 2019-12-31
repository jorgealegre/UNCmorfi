//
// Copyright © 2019 George Alegre. All rights reserved.
//

import XCTest

class UsersPage: Page {

    private enum Button: String, Locator {
        case add = "add-button"
        case edit = "edit-button"
    }

    @discardableResult
    func user(at index: Int) -> UserUIElement {
        UserUIElement(app.tables.cells.element(boundBy: index))
    }

    @discardableResult
    func addUser() -> AddUserOptionsPage {
        app.buttons[Button.add].tap()

        return AddUserOptionsPage(app: app, testCase: testCase)
    }
}

class UserUIElement {

    enum Element: String, Locator {
        case name = "user-name"
        case barcode = "user-barcode"
        case balance = "user-balance"
    }

    private let uiElement: XCUIElement

    init(_ uiElement: XCUIElement) {
        self.uiElement = uiElement
    }

    func get(_ element: Element) -> XCUIElement {
        uiElement.staticTexts[element].firstMatch
    }
}
