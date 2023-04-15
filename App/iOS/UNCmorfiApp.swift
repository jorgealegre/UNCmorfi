import SwiftUI

@main
struct UNCmorfiApp: App {

    init() {
        // Sets the tint color for every view, even sheets and alerts.
        UIView.appearance().tintColor = UIColor(named: "AccentColor")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
