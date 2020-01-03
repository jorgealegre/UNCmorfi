//
// Copyright © 2020 George Alegre. All rights reserved.
//

import UIKit
import UNCmorfiUI

class MainNavigator: Navigator {

    enum Destination: Int {
        case users
        case menu
        case servings
        case locations
        case information
    }

    private let tabBarController: UITabBarController

    let usersNavigator: UsersNavigator

    init(tabBarController: UITabBarController) {
        tabBarController.restorationIdentifier = "TabBarController"

        let usersViewController = UserTableViewController()
        usersNavigator = UsersNavigator(usersViewController: usersViewController)
        usersViewController.navigator = usersNavigator

        // Create all the view controllers for the tab bar controller.

        let users = UINavigationController(rootViewController: usersViewController)
        users.restorationIdentifier = "UsersNavigationController"
        users.tabBarItem = UITabBarItem(
            title: "balance.tab.label".localized(),
            image: TabBarIcon.users.image,
            selectedImage: nil)
        users.tabBarItem.accessibilityIdentifier = "users"

        let menu = UINavigationController(rootViewController: MenuViewController())
        menu.restorationIdentifier = "MenuNavigationController"
        menu.tabBarItem = UITabBarItem(
            title: "menu.tab.label".localized(),
            image: TabBarIcon.menu.image,
            selectedImage: nil)
        menu.tabBarItem.accessibilityIdentifier = "menu"

        let servings = UINavigationController(rootViewController: ServingsViewController())
        servings.restorationIdentifier = "ServingsNavigationController"
        servings.tabBarItem = UITabBarItem(
            title: "counter.tab.label".localized(),
            image: TabBarIcon.servings.image,
            selectedImage: nil)
        servings.tabBarItem.accessibilityIdentifier = "servings"

        let locations = UINavigationController(rootViewController: LocationsViewController())
        locations.restorationIdentifier = "LocationsNavigationController"
        locations.tabBarItem = UITabBarItem(
            title: "map.tab.label".localized(),
            image: TabBarIcon.locations.image,
            selectedImage: nil)
        locations.tabBarItem.accessibilityIdentifier = "locations"

        let info = UINavigationController(rootViewController: InfoViewController())
        info.restorationIdentifier = "InformationNavigationController"
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
        tabBarController.selectedIndex = destination.rawValue
    }
}
