//
// Copyright © 2019 George Alegre. All rights reserved.
//

import XCTest

class TestCase: XCTestCase {

    // MARK: - Properties

    private let app = XCUIApplication()

    // MARK: - Pages

    lazy var tab = TabBar(app: app, testCase: self)
    lazy var usersPage = UsersPage(app: app, testCase: self)
    lazy var menuPage = MenuPage(app: app, testCase: self)
    lazy var servingsPage = ServingsPage(app: app, testCase: self)
    lazy var locationsPage = LocationsPage(app: app, testCase: self)

    override func setUp() {
        continueAfterFailure = false

        app.launchArguments.append("-capturing_screenshots")
        app.launch()
    }

    func takeScreenshot(name screenshotName: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attach = XCTAttachment(screenshot: screenshot, quality: .original)
        attach.name = screenshotName
        attach.lifetime = .keepAlways
        add(attach)
    }
}
