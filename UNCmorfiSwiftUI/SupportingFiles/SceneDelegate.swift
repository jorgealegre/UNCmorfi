//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import SwiftUI
import UNCmorfiKit

let userStore = ObservableUserStore(backingStore: LocalUserStore.shared)

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let contentView = ContentView()
            .environmentObject(userStore)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.tintColor = .systemOrange
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
