//
// Copyright © 2019 George Alegre. All rights reserved.
//

import Foundation

fileprivate extension FileManager {
    func sharedContainerURL() -> URL {
        containerURL(forSecurityApplicationGroupIdentifier: "group.com.georgealegre.UNCmorfi")!
    }
}

class UserStore {

    // MARK: - Singleton

    static let shared = UserStore()

    private init() {
        self.users = loadUsers()
    }

    // MARK: - Properties

    private enum Constants {
        static let archiveURL = FileManager.default.sharedContainerURL().appendingPathComponent("users")
    }

    enum Error: Swift.Error {
        case addingExistingUser
        case addUserFailed
        case userNotFound
        case updatedUsersDontMatchExisting
        case updatingUsersFailed
    }

    private let encoder = JSONEncoder()

    private let decoder = JSONDecoder()

    private(set) var users: [User] = []

    // MARK: - Methods

    /// Load persisted users from disk.
    func reloadUsers() {
        users = loadUsers()
    }

    func addUser(withCode code: String, callback: @escaping ((Result<Void, Error>) -> Void)) {
        guard !users.map({ $0.code }).contains(code) else {
            // User already exists
            DispatchQueue.main.async {
                callback(.failure(.addingExistingUser))
            }
            return
        }

        UNCComedor.shared.getUsers(from: [code]) { [unowned self] result in
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

    func updateUsers(callback: @escaping ((Result<Void, Error>) -> Void)) {
        // Get the user codes needed for the user API.
        let userCodes = users.map { $0.code }

        // Get the updated users from the API.
        UNCComedor.shared.getUsers(from: userCodes) { result in
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

    func swapUser(from: Int, to: Int) {
        users.swapAt(from, to)
        saveUsers()
    }

    func removeUser(at index: Int) {
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
