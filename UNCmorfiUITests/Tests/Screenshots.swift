//
// Copyright © 2019 George Alegre. All rights reserved.
//

import XCTest

/// Tests are separated into multiple classes so that they can run in parallel.

class LocationsTests: TestCase {
    func testLocations() {
        tab.navigateToLocations()

        sleep(5)

        takeScreenshot(name: "locations")
    }
}

class UsersTests: TestCase {
    func testUsers() {
        tab.navigateToUsers()

        takeScreenshot(name: "users")
    }
}

class MenuTests: TestCase {
    func testMenu() {
        tab.navigateToMenu()
            .waitForActivityIndicatorToDisappear(timeout: 10)

        takeScreenshot(name: "menu")
    }
}

class ServingsTests: TestCase {
    func testServings() {
        tab.navigateToServings()

        takeScreenshot(name: "servings")
    }
}
