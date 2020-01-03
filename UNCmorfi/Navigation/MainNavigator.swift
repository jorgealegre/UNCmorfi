//
// Copyright © 2020 George Alegre. All rights reserved.
//

import UIKit
import UNCmorfiUI

class MainNavigator: Navigator {

    enum Destination {
        case users
        case menu
        case servings
        case locations
        case information
    }

    private let tabBarController: UITabBarController

    let usersNavigator: UsersNavigator

    init(tabBarController: UITabBarController) {
        let usersViewController = UserTableViewController()
        usersNavigator = UsersNavigator(usersViewController: usersViewController)
        usersViewController.navigator = usersNavigator

        // Create all the view controllers for the tab bar controller.

        let users = UINavigationController(rootViewController: usersViewController)
        users.tabBarItem = UITabBarItem(
            title: "balance.tab.label".localized(),
            image: TabBarIcon.users.image,
            selectedImage: nil)
        users.tabBarItem.accessibilityIdentifier = "users"

        let menu = UINavigationController(rootViewController: MenuViewController())
        menu.tabBarItem = UITabBarItem(
            title: "menu.tab.label".localized(),
            image: TabBarIcon.menu.image,
            selectedImage: nil)
        menu.tabBarItem.accessibilityIdentifier = "menu"

        let servings = UINavigationController(rootViewController: ServingsViewController())
        servings.tabBarItem = UITabBarItem(
            title: "counter.tab.label".localized(),
            image: TabBarIcon.servings.image,
            selectedImage: nil)
        servings.tabBarItem.accessibilityIdentifier = "servings"

        let locations = UINavigationController(rootViewController: LocationsViewController())
        locations.tabBarItem = UITabBarItem(
            title: "map.tab.label".localized(),
            image: TabBarIcon.locations.image,
            selectedImage: nil)
        locations.tabBarItem.accessibilityIdentifier = "locations"

        let info = UINavigationController(rootViewController: InfoViewController())
        info.tabBarItem = UITabBarItem(
            title: "info.tab.label".localized(),
            image: TabBarIcon.information.image,
            selectedImage: nil)
        info.tabBarItem.accessibilityIdentifier = "info"

        // Add the view controllers to the tab bar controller view controllers.
        tabBarController.viewControllers = [users, menu, servings, locations, info]

        self.tabBarController = tabBarController
    }

    func navigate(to destination: Destination) {
        switch destination {
        case .users:
            tabBarController.selectedIndex = 0
        case .menu:
            tabBarController.selectedIndex = 1
        case .servings:
            tabBarController.selectedIndex = 2
        case .locations:
            tabBarController.selectedIndex = 3
        case .information:
            tabBarController.selectedIndex = 4
        }
    }
}
