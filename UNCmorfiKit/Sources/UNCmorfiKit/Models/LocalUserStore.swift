//
// Copyright © 2019 George Alegre. All rights reserved.
//

import Foundation

fileprivate extension FileManager {
    func sharedContainerURL() -> URL {
        containerURL(forSecurityApplicationGroupIdentifier: "group.com.georgealegre.UNCmorfi")!
    }
}

public class LocalUserStore: UserStore {

    // MARK: - Singleton

    public static let shared = LocalUserStore()

    private init() {
        self.users = loadUsers()
    }

    // MARK: - Properties

    private enum Constants {
        static let archiveURL = FileManager.default.sharedContainerURL().appendingPathComponent("users")
    }

    private let encoder = JSONEncoder()

    private let decoder = JSONDecoder()

    public private(set) var users: [User] = []

    // MARK: - Methods

    /// Load persisted users from disk.
    public func reloadUsers() {
        users = loadUsers()
    }

    public func addUser(withCode code: String, callback: @escaping ((Result<Void, UserStoreError>) -> Void)) {
        guard !users.map({ $0.code }).contains(code) else {
            // User already exists
            DispatchQueue.main.async {
                callback(.failure(.addingExistingUser))
            }
            return
        }

        URLSession.shared.load(.users(from: [code])) { [unowned self] result in
            switch result {
            case let .success(users) where !users.isEmpty:
                let user = users.first!
                self.users.append(user)
                self.saveUsers()
                DispatchQueue.main.async {
                    callback(.success(()))
                }
            case .success:
                DispatchQueue.main.async {
                    callback(.failure(.userNotFound))
                }
            case let .failure(error):
                print(error)
                DispatchQueue.main.async {
                    callback(.failure(.addUserFailed))
                }
            }
        }
    }

    public func updateUsers(callback: @escaping ((Result<Void, UserStoreError>) -> Void)) {
        // Exit early if we don't have users.
        guard !users.isEmpty else {
            callback(.success(()))
            return
        }

        // Get the barcode from each user.
        let userCodes = users.map { $0.code }

        // Get the updated users from the API.
        URLSession.shared.load(.users(from: userCodes)) { result in
            switch result {
            case let .success(users):
                guard let users = try? users.matchingOrder(of: self.users) else {
                    DispatchQueue.main.async {
                        callback(.failure(.updatedUsersDontMatchExisting))
                    }
                    return
                }

                self.users = users
                self.saveUsers()

                DispatchQueue.main.async {
                    callback(.success(()))
                }
            case .failure:
                // TODO: handle error
                DispatchQueue.main.async {
                    callback(.failure(.updatingUsersFailed))
                }
            }
        }
    }

    public func swapUser(from: Int, to: Int) {
        users.swapAt(from, to)
        saveUsers()
    }

    public func removeUser(at index: Int) {
        users.remove(at: index)
        saveUsers()
    }

    // MARK: - Persistance

    private func saveUsers() {
        do {
            let data = try encoder.encode(users)
            try data.write(to: Constants.archiveURL)
        } catch {
            print("Error: \(error).")
        }
    }

    private func loadUsers() -> [User] {
        do {
            let data = try Data(contentsOf: Constants.archiveURL)
            return try decoder.decode([User].self, from: data)
        } catch {
            print("Error: \(error).")
            return []
        }
    }
}
