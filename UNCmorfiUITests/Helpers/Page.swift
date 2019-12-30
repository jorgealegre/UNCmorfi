//
// Copyright © 2019 George Alegre. All rights reserved.
//

import XCTest

class Page {
    let app: XCUIApplication
    let testCase: TestCase
    let timeoutMultiplier: Double = 1

    init(app: XCUIApplication, testCase: TestCase) {
        self.app = app
        self.testCase = testCase
    }

    @discardableResult
    func waitForActivityIndicatorToDisappear(timeout: TimeInterval) -> Self {
        testCase.wait(for: app.activityIndicators["activity-indicator"], toAppear: false, timeout: timeout * timeoutMultiplier)
        return self
    }
}
