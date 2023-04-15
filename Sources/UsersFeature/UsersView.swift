import ComposableArchitecture
import SharedModels
import SwiftUI

public struct UsersState: Equatable {
    var addUserManuallyAlert: AlertState<UsersAction.AddUserManuallyAction>?
    var confirmationDialog: ConfirmationDialogState<UsersAction.AddUserAction>?
    var isCameraModalShown: Bool
    var users: [User]

    public init(
        addUserManuallyAlert: AlertState<UsersAction.AddUserManuallyAction>? = nil,
        confirmationDialog: ConfirmationDialogState<UsersAction.AddUserAction>? = nil,
        isCameraModalShown: Bool = false,
        users: [User] = []
    ) {
        self.addUserManuallyAlert = addUserManuallyAlert
        self.confirmationDialog = confirmationDialog
        self.isCameraModalShown = isCameraModalShown
        self.users = users
    }
}

public enum UsersAction: Equatable {

    public enum AddUserAction {
        case cancel
        case fromCamera
        case fromGallery
        case manually
    }

    public enum AddUserManuallyAction {
        case add
        case cancel
    }

    case addButtonTapped
    case addUser(AddUserAction)
    case addUserManually(AddUserManuallyAction)
    case fetchUser(code: String)
    case onAppear
    case setIsCameraModalShown(Bool)
}

public struct UsersEnvironment {
    public var presentCamera: () -> Void

    public init(
        presentCamera: @escaping () -> Void
    ) {
        self.presentCamera = presentCamera
    }

    static let failing = Self(
        presentCamera: { }
    )
}

public let usersReducer: Reducer<
    UsersState, UsersAction, UsersEnvironment
> = Reducer { state, action, environment in
    switch action {
    case .addButtonTapped:
        state.confirmationDialog = ConfirmationDialogState(
            title: TextState("How"),
            buttons: [
                .default(TextState("Manual"), action: .send(.manually)),
                .default(TextState("Camera"), action: .send(.fromCamera)),
                .default(TextState("Gallery"), action: .send(.fromGallery)),
                .cancel(TextState("Cancel"))
            ]
        )
        return .none

    case .addUser(.manually):
        state.confirmationDialog = nil
        state.addUserManuallyAlert = .init(
            title: TextState("Add a new person"),
            message: TextState("Type the barcode"),
            buttons: [
                .default(TextState("Add"), action: .send(.add)),
                .cancel(TextState("Cancel"))
            ]
        )
        return .none

    case .addUser(.fromCamera):
        state.confirmationDialog = nil
        state.isCameraModalShown = true
        return .fireAndForget { environment.presentCamera() }

    case .addUser(.fromGallery):
        state.confirmationDialog = nil
        return .none

    case .addUser(.cancel):
        state.confirmationDialog = nil
        return .none

    case .addUserManually(.add):
        state.addUserManuallyAlert = nil
        return .none

    case .addUserManually(.cancel):
        state.addUserManuallyAlert = nil
        return .none

    case let .fetchUser(code):
        return .none

    case .onAppear:
        return .none

    case let .setIsCameraModalShown(value):
        state.isCameraModalShown = value
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
                    Button(action: { viewStore.send(.addButtonTapped) }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onAppear { viewStore.send(.onAppear) }
        .confirmationDialog(
            store.scope(
                state: \.confirmationDialog,
                action: UsersAction.addUser
            ),
            dismiss: .cancel
        )
        .alert(
            store.scope(
                state: \.addUserManuallyAlert,
                action: UsersAction.addUserManually
            ),
            dismiss: .cancel
        )
        .sheet(
            isPresented: viewStore.binding(
                get: \.isCameraModalShown,
                send: UsersAction.setIsCameraModalShown
            )
        ) {
            Color.red.frame(width: 400, height: 900)
        }
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
                    environment: .failing
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
                    environment: .failing
                )
            )
            .preferredColorScheme(.dark)
        }
        .tint(.orange)
    }
}
