//
// Copyright © 2019 George Alegre. All rights reserved.
//

import XCTest

class TabBar: Page {

    private enum Tab: String, Locator {
        case users
        case menu
        case servings
        case locations
        case info
    }

    @discardableResult
    func navigateToUsers() -> UsersPage {
        app.tabBars.buttons[Tab.users].tap()

        return testCase.usersPage
    }

    @discardableResult
    func navigateToMenu() -> MenuPage {
        app.tabBars.buttons[Tab.menu].tap()

        return testCase.menuPage
    }

    @discardableResult
    func navigateToServings() -> ServingsPage {
        app.tabBars.buttons[Tab.servings].tap()

        return testCase.servingsPage
    }

    @discardableResult
    func navigateToLocations() -> LocationsPage {
        app.tabBars.buttons[Tab.locations].tap()

        return testCase.locationsPage
    }
}
