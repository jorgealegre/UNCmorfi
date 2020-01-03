//
// Copyright © 2019 George Alegre. All rights reserved.
//

import SwiftUI
import UNCmorfiKit
import Combine

struct UsersView: View {
    @ObservedObject private var userStore: ObservableUserStore

    @State private var showAddUserOptions = false

    @State private var showManualUserInputForm = false

    init(userStore: ObservableUserStore) {
        self.userStore = userStore
    }

    var body: some View {
        List {
            ForEach(userStore.users, content: UserRow.init)
                .onMove(perform: move)
                .onDelete(perform: delete)
        }
        .navigationBarItems(leading: EditButton(), trailing: addButton)
        .actionSheet(isPresented: $showAddUserOptions, content: { actionSheet })
        .alert(isPresented: $showManualUserInputForm, content: { alert })
        .navigationBarTitle("Balance")
    }

    private var addButton: some View {
        Button(action: {
            self.showAddUserOptions = true
        }) {
            Image(systemName: "plus")
                .imageScale(.large)
                .padding()
        }
    }

    private var actionSheet: ActionSheet {
        ActionSheet(title: Text("Chose an input method"), message: nil, buttons: [
            .default(Text("Manual")) {
                self.showManualUserInputForm = true
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

    private func move(from source: IndexSet, to destination: Int) {
        userStore.swapUser(from: source.first!, to: destination)
    }

    private func delete(at offsets: IndexSet) {
        userStore.removeUser(at: offsets.first!)
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TabView {
                NavigationView {
                    UsersView(userStore: ObservableUserStore(backingStore: LocalUserStore.shared))
                }
            }
            .accentColor(.orange)

//            TabView {
//                NavigationView {
//                    UsersView(userStore: ObservableUserStore(backingStore: LocalUserStore.shared))
//                }
//            }
//            .accentColor(.orange)
//            .environment(\.locale, Locale(identifier: "es_AR"))
        }
    }
}
