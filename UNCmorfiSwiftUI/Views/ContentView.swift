//
// Copyright © 2019 George Alegre. All rights reserved.
//

import SwiftUI
import UNCmorfiKit

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                UsersView(userStore: ObservableUserStore.shared)
            }
            .tabItem { Text("Balance") }
            .tag(1)

            NavigationView {
                MenuView()
            }
            .tabItem { Text("Menu") }
            .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
