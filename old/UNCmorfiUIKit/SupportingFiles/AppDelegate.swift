//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import Alamofire
import UNCmorfiKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    var navigator: MainNavigator!

    func application(_ application: UIApplication,
                     willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        // When capturing screenshots, we prefer Dark Mode.
        if Settings.capturingScreenshots {
            if #available(iOS 13.0, *) {
                window?.overrideUserInterfaceStyle = .dark
            }
        }

        // Apply a system wide orange tint color.
        window?.tintColor = .systemOrange

        let tabBarController = UITabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        navigator = MainNavigator(tabBarController: tabBarController)

        return true
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // The user images don't have the correct Content Type header.
//        DataRequest.addAcceptableImageContentTypes(["application/octet-stream"])

        // Configure background fetching. Once every day seems fine.
        application.setMinimumBackgroundFetchInterval(60 * 60 * 24)

        return true
    }

    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Services.userStore.updateUsers { _ in
            completionHandler(.newData)
        }
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type.contains("scanbarcode") {
            navigator.navigate(to: .users)
            navigator.usersNavigator.navigate(to: .barcodeScanner)

            completionHandler(true)
            return
        }

        completionHandler(false)
    }

    func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        true
    }

    func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
        true
    }
}
