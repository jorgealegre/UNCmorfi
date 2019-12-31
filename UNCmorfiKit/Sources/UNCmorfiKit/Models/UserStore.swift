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
/// Wrapper for `UserStore` to use `Combine`.
public class ObservableUserStore: UserStore, ObservableObject {

    // MARK: - Properties

    private let backingStore: UserStore

    public var users: [User] { backingStore.users }

    public let objectWillChange = PassthroughSubject<Void, Never>()

    // MARK: - Initializers

    public init(backingStore: UserStore) {
        self.backingStore = backingStore
    }

    public func reloadUsers() {
        backingStore.reloadUsers()
        objectWillChange.send()
    }

    public func addUser(withCode code: String, callback: @escaping (Result<Void, UserStoreError>) -> Void) {
        backingStore.addUser(withCode: code) { result in
            callback(result)
            self.objectWillChange.send()
        }
    }

    public func updateUsers(callback: @escaping (Result<Void, UserStoreError>) -> Void) {
        backingStore.updateUsers { result in
            callback(result)
            self.objectWillChange.send()
        }
    }

    public func swapUser(from: Int, to: Int) {
        backingStore.swapUser(from: from, to: to)
        objectWillChange.send()
    }

    public func removeUser(at index: Int) {
        backingStore.removeUser(at: index)
        objectWillChange.send()
    }
}
#endif
