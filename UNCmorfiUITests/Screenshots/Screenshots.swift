//
// Copyright © 2019 George Alegre. All rights reserved.
//

import XCTest

/// Tests are separated into multiple classes so that they can run in parallel.

class UsersScreenshot: ScreenshotTestCase {
    func testUsers() {
        tab.navigateToUsers()

        takeScreenshot(name: "users")
    }
}

class MenuScreenshot: ScreenshotTestCase {
    func testMenu() {
        tab.navigateToMenu()
            .waitForActivityIndicatorToDisappear(timeout: 10)

        takeScreenshot(name: "menu")
    }
}

class ServingsScreenshot: ScreenshotTestCase {
    func testServings() {
        tab.navigateToServings()

        takeScreenshot(name: "servings")
    }
}

class LocationsScreenshot: ScreenshotTestCase {
    func testLocations() {
        tab.navigateToLocations()

        sleep(5)

        takeScreenshot(name: "locations")
    }
}
