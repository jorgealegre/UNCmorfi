import ComposableArchitecture
import SwiftUI

public struct User: Identifiable, Equatable {
    public let balance: Int
    public let expirationDate: Date
    public let id: String
    public let imageURL: URL?
    public let name: String
    public let type: String

    public init(
        balance: Int = 0,
        expirationDate: Date,
        id: String,
        imageURL: URL? = nil,
        name: String,
        type: String
    ) {
        self.balance = balance
        self.expirationDate = expirationDate
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.type = type
    }
}

public struct UsersState: Equatable {
    var users: [User]

    public init(
        users: [User] = []
    ) {
        self.users = users
    }
}

public enum UsersAction: Equatable {
    case fetchUser(code: String)
    case onAppear
}

public struct UsersEnvironment {

    public init(
    ) {
    }
}

public let usersReducer: Reducer<UsersState, UsersAction, UsersEnvironment> = Reducer { state, action, environment in
    switch action {
    case let .fetchUser(code):
        return .none

    case .onAppear:
        return .none
    }
}

public struct UsersView: View {
    let store: Store<UsersState, UsersAction>
    @ObservedObject var viewStore: ViewStore<UsersState, UsersAction>

    public init(store: Store<UsersState, UsersAction>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }

    public var body: some View {
        NavigationView {
            List {
                ForEach(viewStore.users) { user in
                    Text(user.name)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Users")
        }
        .onAppear { viewStore.send(.onAppear) }
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView(
            store: .init(
                initialState: .init(
                    users: [
                        User(
                            balance: 132,
                            expirationDate: Date().addingTimeInterval(4 * 24 * 60 * 60),
                            id: "04756A29333C62D",
                            imageURL: URL(string: "https://asiruws.unc.edu.ar/foto/fbb431f8-5e63-48f8-afac-bdf1de79966f")!,

                            name: "Jorge Facundo Alegre",
                            type: "Estudiante de Grado"
                        ),
                        User(
                            balance: 132,
                            expirationDate: Date().addingTimeInterval(4 * 24 * 60 * 60),
                            id: "04756A29333C62D",
                            imageURL: URL(string: "https://asiruws.unc.edu.ar/foto/fbb431f8-5e63-48f8-afac-bdf1de79966f")!,

                            name: "Jorge Facundo Alegre",
                            type: "Estudiante de Grado"
                        )
                    ]
                ),
                reducer: usersReducer,
                environment: UsersEnvironment()
            )
        )
            .preferredColorScheme(.dark)
    }
}
