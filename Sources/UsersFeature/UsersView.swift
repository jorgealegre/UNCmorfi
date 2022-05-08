import ComposableArchitecture
import SharedModels
import SwiftUI

public struct UsersState: Equatable {
    var users: [User]

    public init(
        users: [User] = []
    ) {
        self.users = users
    }
}

public enum UsersAction: Equatable {
    case addButtonTapped
    case fetchUser(code: String)
    case onAppear
}

public struct UsersEnvironment {

    public init(
    ) {
    }
}

public let usersReducer: Reducer<
    UsersState, UsersAction, UsersEnvironment
> = Reducer { state, action, environment in
    switch action {
    case .addButtonTapped:
        return .none

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
                    UserView(user: user)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewStore.send(.addButtonTapped)
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }

        }
        .onAppear { viewStore.send(.onAppear) }
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UsersView(
                store: .init(
                    initialState: .init(
                        users: [
                            .mock1,
                            .mock2
                        ]
                    ),
                    reducer: usersReducer,
                    environment: UsersEnvironment()
                )
            )

            UsersView(
                store: .init(
                    initialState: .init(
                        users: [
                            .mock1,
                            .mock2
                        ]
                    ),
                    reducer: usersReducer,
                    environment: UsersEnvironment()
                )
            )
            .preferredColorScheme(.dark)
        }
        .tint(.orange)
    }
}
