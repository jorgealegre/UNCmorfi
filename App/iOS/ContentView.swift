import UsersFeature
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                UsersView(
                    store: .init(
                        initialState: UsersState(),
                        reducer: usersReducer,
                        environment: UsersEnvironment(
                            presentCamera: {
                                
                            }
                        )
                    )
                )
            }
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("Users")
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .accentColor(.orange)
    }
}
