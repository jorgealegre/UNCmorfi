//
//  TabBarController.swift
//  UNCmorfi
//
//  Created by George Alegre on 6/3/17.
//  Copyright © 2017 George Alegre. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let balance = UINavigationController(rootViewController: UserTableViewController())
        balance.tabBarItem = UITabBarItem(title: "Balance", image: nil, selectedImage: nil)
        
        let menu = MenuViewController()
        menu.tabBarItem = UITabBarItem(title: "Menú", image: nil, selectedImage: nil)
        
        viewControllers = [balance, menu]
    }
}
