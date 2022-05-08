//
// Copyright © 2020 alegre.dev. All rights reserved.
//

import SwiftUI
import UNCmorfiKit
import UNCmorfiUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                UsersView(userStore: ObservableUserStore())
            }
            .tabItem {
                Image(uiImage: TabBarIcon.users.image)
                Text("Balance")
            }

            NavigationView {
                MenuView()
            }
            .tabItem {
                Image(uiImage: TabBarIcon.menu.image)
                Text("Menu")
            }

            NavigationView {
                MenuView()
            }
            .tabItem {
                Image(uiImage: TabBarIcon.servings.image)
                Text("Servings")
            }

            NavigationView {
                MenuView()
            }
            .tabItem {
                Image(uiImage: TabBarIcon.locations.image)
                Text("Locations")
            }

            NavigationView {
                MenuView()
            }
            .tabItem {
                Image(uiImage: TabBarIcon.information.image)
                Text("Information")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
