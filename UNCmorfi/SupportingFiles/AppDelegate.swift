//
//  AppDelegate.swift
//  UNCmorfi
//
//  Created by George Alegre on 4/3/17.
//
//  LICENSE is at the root of this project's repository.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: variables
    var window: UIWindow?
    let appRunCount: AppRunCount = AppRunCountImpl()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        
        appRunCount.increment()
        return true
    }
}
