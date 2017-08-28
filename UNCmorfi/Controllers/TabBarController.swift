//
//  TabBarController.swift
//  UNCmorfi
//
//  Created by George Alegre on 8/27/17.
//  Copyright © 2017 George Alegre. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create all the view controllers for the tab bar controller.
        let balance = UINavigationController(rootViewController: UserTableViewController())
        balance.tabBarItem = UITabBarItem(title: "Balance", image: nil, selectedImage: nil)
        
        let menu = UINavigationController(rootViewController: MenuViewController())
        menu.tabBarItem = UITabBarItem(title: "Menu", image: nil, selectedImage: nil)
        
        let map = UINavigationController(rootViewController: MapViewController())
        map.tabBarItem = UITabBarItem(title: "Comedores", image: nil, selectedImage: nil)
        
        // Add the view controllers to the tab bar controller view controllers.
        viewControllers = [balance, menu, map]
    }
}
