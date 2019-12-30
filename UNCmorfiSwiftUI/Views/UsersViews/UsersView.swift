//
// Copyright © 2019 George Alegre. All rights reserved.
//

import SwiftUI
import UNCmorfiKit
import Combine

let users = [User(name: "Jorge Facundo Alegre",
                  code: "04756A29333C62D",
                  balance: 184,
                  imageURL: URL(string: "https://asiruws.unc.edu.ar/foto/fbb431f8-5e63-48f8-afac-bdf1de79966f")!,
                  expirationDate: Date(),
                  type: "Estudiante de Grado")]

struct UsersView: View {
    @ObservedObject
    var userStore: ObservableUserStore

    @State
    private var showingAddUserOption = false

    @State
    private var showingManualUserInput = false

    var body: some View {
        List {
            ForEach(userStore.users) { balance in
                BalanceRow(balance: balance)
            }
            .onMove(perform: move)
            .onDelete(perform: delete)
        }
        .navigationBarItems(leading: EditButton())
        .navigationBarItems(trailing: addButton)
        .actionSheet(isPresented: $showingAddUserOption, content: { actionSheet })
        .alert(isPresented: $showingManualUserInput, content: { alert })
        .navigationBarTitle("Balance")
    }

    private var addButton: some View {
        Button(action: {
            self.showingAddUserOption = true
        }) {
            Image(systemName: "plus")
                .font(.headline)
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

    }

    func delete(at offsets: IndexSet) {

    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            NavigationView {
                UsersView(userStore: ObservableUserStore.shared)
            }
        }
        .accentColor(.orange)
    }
}
