//
// Copyright © 2019 George Alegre. All rights reserved.
//

import XCTest

class AddUserOptionsPage: Page {
    private enum Button: String, Locator {
        case manually
        case photo
        case camera
        case cancel
    }

    @discardableResult
    func manually() -> BarcodeInputPage {
        app.sheets.buttons.element(boundBy: 0).tap()

        return BarcodeInputPage(app: app, testCase: testCase)
    }
}
