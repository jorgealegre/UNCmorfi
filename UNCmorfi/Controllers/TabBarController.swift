//
//  TabBarController.swift
//  UNCmorfi
//
//  Created by George Alegre on 8/27/17.
//
//  LICENSE is at the root of this project's repository.
//

import UIKit
import FontAwesome_swift

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create all the view controllers for the tab bar controller.
        // Standard tab bar item image size.
        let size = CGSize(width: 30, height: 30)

        let balance = UINavigationController(rootViewController: UserTableViewController())
        let balanceImage = UIImage.fontAwesomeIcon(name: .idCardO, textColor: .black, size: size)
        balance.tabBarItem = UITabBarItem(
            title: NSLocalizedString("balance.label", comment: "Balance"),
            image: balanceImage,
            selectedImage: nil)
        
        let menu = UINavigationController(rootViewController: MenuViewController())
        let menuImage = UIImage.fontAwesomeIcon(name: .cutlery, textColor: .black, size: size)
        menu.tabBarItem = UITabBarItem(
            title: "Menu",
            image: menuImage,
            selectedImage: nil)
        
        let map = UINavigationController(rootViewController: MapViewController())
        let mapImage = UIImage.fontAwesomeIcon(name: .mapO, textColor: .black, size: size)
        map.tabBarItem = UITabBarItem(
            title: "Comedores",
            image: mapImage,
            selectedImage: nil)

        let counter = UINavigationController(rootViewController: CounterViewController())
        let counterImage = UIImage.fontAwesomeIcon(name: .lineChart, textColor: .black, size: size)
        counter.tabBarItem = UITabBarItem(
            title: "Raciones",
            image: counterImage,
            selectedImage: nil)

        let info = UINavigationController(rootViewController: InfoViewController())
        let infoImage = UIImage.fontAwesomeIcon(name: .infoCircle, textColor: .black, size: size)
        info.tabBarItem = UITabBarItem(
            title: "Información",
            image: infoImage,
            selectedImage: nil)
        
        // Add the view controllers to the tab bar controller view controllers.
        viewControllers = [balance, menu, counter, map, info]

        // Preload all view controllers when launching app.
        viewControllers!
            .map { ($0 as! UINavigationController).viewControllers.first! }
            .filter { !($0 is MapViewController) }
            .forEach { viewController in let _ = viewController.view }
    }
}
