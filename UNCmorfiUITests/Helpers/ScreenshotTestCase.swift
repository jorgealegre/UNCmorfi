//
// Copyright © 2019 George Alegre. All rights reserved.
//

import XCTest

class ScreenshotTestCase: TestCase {

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
