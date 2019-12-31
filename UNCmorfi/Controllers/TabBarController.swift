//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import UNCmorfiUI

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create all the view controllers for the tab bar controller.

        let users = UINavigationController(rootViewController: UserTableViewController())
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
        viewControllers = [users, menu, servings, locations, info]
    }
}
