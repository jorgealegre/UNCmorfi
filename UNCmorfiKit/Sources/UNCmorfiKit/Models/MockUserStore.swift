//
// Copyright © 2019 George Alegre. All rights reserved.
//

import Foundation

class MockUserStore: UserStore {

    // MARK: - Singleton

    static let shared = MockUserStore()

    private init() {}

    // MARK: - UserStore

    var users: [User] {
        [User(name: "Jorge Facundo Alegre",
             code: "04756A29333C62D",
             balance: 184,
             imageURL: URL(string: "https://asiruws.unc.edu.ar/foto/fbb431f8-5e63-48f8-afac-bdf1de79966f")!,
             expirationDate: Date(),
             type: "Estudiante de Grado")]
    }

    func reloadUsers() {
    }

    func addUser(withCode code: String, callback: @escaping (Result<Void, UserStoreError>) -> Void) {
        callback(.success(()))
    }

    func updateUsers(callback: @escaping (Result<Void, UserStoreError>) -> Void) {
        callback(.success(()))
    }

    func swapUser(from: Int, to: Int) {
    }

    func removeUser(at index: Int) {
    }
}
