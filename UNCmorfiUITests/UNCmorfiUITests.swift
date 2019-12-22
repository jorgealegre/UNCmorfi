//
// Copyright © 2019 George Alegre. All rights reserved.
//

import XCTest

class UNCmorfiUITests: XCTestCase {

    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
    }

    func testBalance() {
        XCUIApplication().tabBars.buttons["balance"].tap()

        snapshot("balance")
    }

    func testMenu() {
        XCUIApplication().tabBars.buttons["menu"].tap()

        snapshot("menu")
    }

    func testServings() {
        XCUIApplication().tabBars.buttons["counter"].tap()

        snapshot("servings")
    }

    func testLocations() {
        XCUIApplication().tabBars.buttons["map"].tap()

        snapshot("locations")
    }
}
