//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: variables
    var window: UIWindow?
    let appRunCount: AppRunCount = AppRunCountImpl()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        DataRequest.addAcceptableImageContentTypes(["application/octet-stream"])

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.tintColor = .systemOrange
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        
        appRunCount.increment()
        return true
    }
}
