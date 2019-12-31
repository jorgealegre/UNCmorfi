//
// Copyright © 2019 George Alegre. All rights reserved.
//

import XCTest

class BarcodeInputPage: Page {
    @discardableResult
    func typeBarcode(_ barcode: String) -> Self {
        app.alerts.textFields.firstMatch.typeText(barcode)

        return self
    }

    @discardableResult
    func done() -> UsersPage {
        return tapButton(1)
    }

    @discardableResult
    func cancel() -> UsersPage {
        return tapButton(0)
    }

    private func tapButton(_ index: Int) -> UsersPage {
        let handler = testCase.addUIInterruptionMonitor(withDescription: "Barcode Input Alert") { alert -> Bool in
            alert.buttons.element(boundBy: index).tap()
            return true
        }
        app.tap()

        testCase.removeUIInterruptionMonitor(handler)

        return testCase.usersPage
    }
}
