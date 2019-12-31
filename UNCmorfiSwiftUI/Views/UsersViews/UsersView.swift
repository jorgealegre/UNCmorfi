//
// Copyright © 2019 George Alegre. All rights reserved.
//

import SwiftUI
import UNCmorfiKit
import Combine

struct UsersView: View {
    @ObservedObject var userStore: ObservableUserStore

    @State private var showingAddUserOption = false

    @State private var showingManualUserInput = false

    var body: some View {
        List {
            ForEach(userStore.users) { user in
                UserRow(user: user)
            }
            .onMove(perform: move)
            .onDelete(perform: delete)
        }
        .navigationBarItems(leading: EditButton(), trailing: addButton)
        .actionSheet(isPresented: $showingAddUserOption, content: { actionSheet })
        .alert(isPresented: $showingManualUserInput, content: { alert })
        .navigationBarTitle("Balance")
    }

    private var addButton: some View {
        Button(action: {
            self.showingAddUserOption = true
        }) {
            Image(systemName: "plus").imageScale(.large)
        }
    }

    private var actionSheet: ActionSheet {
        ActionSheet(title: Text("Chose an input method"), message: nil, buttons: [
            .default(Text("Manual")) {
                self.showingManualUserInput = true
            },
            .default(Text("Camera")) {
                print("camera")
            },
            .default(Text("Photo")) {
                print("photo")
            },
            .cancel(Text("Cancel")),
        ])
    }

    private var alert: Alert {
        Alert(title: Text("Add a new person"),
              message: Text("Type the barcode"),
              primaryButton: .cancel(),
              secondaryButton: .default(Text("Done"), action: {
                print("add user")
        }))
    }

    func move(from source: IndexSet, to destination: Int) {
        userStore.swapUser(from: source.first!, to: destination)
    }

    func delete(at offsets: IndexSet) {
        userStore.removeUser(at: offsets.first!)
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            NavigationView {
                UsersView(userStore: userStore)
            }
        }
        .accentColor(.orange)
    }
}
