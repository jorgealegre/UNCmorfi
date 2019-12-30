//
// Copyright © 2019 George Alegre. All rights reserved.
//

import Foundation

public protocol UserStore {
    var users: [User] { get }

    func reloadUsers()

    func addUser(withCode code: String, callback: @escaping (Result<Void, UserStoreError>) -> Void)

    func updateUsers(callback: @escaping (Result<Void, UserStoreError>) -> Void)

    func swapUser(from: Int, to: Int)

    func removeUser(at index: Int)
}

public enum UserStoreError: Error {
    case addingExistingUser
    case addUserFailed
    case userNotFound
    case updatedUsersDontMatchExisting
    case updatingUsersFailed
}

#if canImport(Combine)
import Combine

@available(iOS 13.0, *)
public class ObservableUserStore: ObservableObject {

    // MARK: - Singleton

    public static let shared = ObservableUserStore()

    private init() {
        self.users = store.users
    }

    // MARK: - Properties

    private let store = Services.userStore

    @Published public var users: [User]
}

#endif
