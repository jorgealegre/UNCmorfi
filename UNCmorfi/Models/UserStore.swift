//
//  UserStore.swift
//  UNCmorfi
//
//  Created by George Alegre on 11/11/2019.
//  Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit

class UserStore {

    // MARK: - Singleton

    static let shared = UserStore()

    private init() {}

    // MARK: - Properties

    private enum Constants {
        private static let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        static let archiveURL = documentsDirectory.appendingPathComponent("users")
    }

    var users: [User] = []

    // MARK: - Methods

    func addUser(_ user: User) {
        // Make sure it doesn't already exist.
        guard !users.contains(user) else { return }
        users.append(user)

        saveUsers()
    }

    func updateUsers(callback: @escaping (() -> Void)) {
        // Create a queue for parallel jobs.
        let queue = DispatchQueue.global(qos: .userInitiated)
        let group = DispatchGroup()

        // Return the original data if the update fails.
        var updateFailed = false
        let backup: [User] = users

        var result: [User] = []
        var images: [String: UIImage] = [:]

        // Get the user codes needed for the user API.
        let userCodes = users.map { $0.code }

        // Get the updated users from the API.
        group.enter()
        UNCComedor.shared.getUsers(from: userCodes) { (apiResult) in
            // Notify that this task is done.
            defer { group.leave() }

            switch apiResult {
            case .failure(let error):
                // TODO: handle error
                updateFailed = true
                return
            case .success(let users):
                result = users

                // Get the updated user images from the API.
                users.forEach { (user) in
                    group.enter()

                    UNCComedor.shared.getUserImage(from: user.imageURL!) { imageResult in
                        // Notify that this task is done.
                        defer { group.leave() }

                        switch imageResult {
                        case .failure(_):
                            // TODO: handle error
                            updateFailed = true
                            return
                        case .success(let image):
                            user.image = image
                        }
                    }
                }
            }
        }

        // When all tasks have finished.
        group.notify(queue: queue) {
            DispatchQueue.main.async {
                if updateFailed {
                    callback()
                } else {
                    self.users = (try? result.matchingOrder(of: self.users)) ?? backup
                    self.saveUsers()
                    callback()
                }
            }
        }
    }

    // MARK: - Persistance

    func saveUsers() {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(users)
            try data.write(to: Constants.archiveURL)
        } catch {
            print("Error: \(error).")
        }
    }

    func loadUsers() {
        let jsonDecoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: Constants.archiveURL)
            users = try jsonDecoder.decode([User].self, from: data)
        } catch {
            print("Error: \(error).")
        }
    }
}
