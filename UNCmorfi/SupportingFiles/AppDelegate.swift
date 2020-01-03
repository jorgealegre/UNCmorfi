//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import Alamofire
import UNCmorfiKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // The user images don't have the correct Content Type header.
        DataRequest.addAcceptableImageContentTypes(["application/octet-stream"])

        // Configure background fetching. Once every day seems fine.
        application.setMinimumBackgroundFetchInterval(60 * 60 * 24)

        window = UIWindow(frame: UIScreen.main.bounds)

        // When capturing screenshots, we prefer Dark Mode.
        if Settings.capturingScreenshots {
            if #available(iOS 13.0, *) {
                window?.overrideUserInterfaceStyle = .dark
            }
        }

        // Apply a system wide orange tint color.
        window?.tintColor = .systemOrange

        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        
        return true
    }

    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Services.userStore.updateUsers { _ in
            completionHandler(.newData)
        }
    }
}
