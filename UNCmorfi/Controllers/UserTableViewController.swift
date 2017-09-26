//
//  UserTableViewController.swift
//  UNCmorfi
//
//  Created by George Alegre on 4/25/17.
//
//  LICENSE is at the root of this project's repository.
//

import UIKit
import os.log

class UserTableViewController: UITableViewController {
    // MARK: Properties
    private var users: [User] = []

    // MARK: Setup.
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = NSLocalizedString("balance.nav.label", comment: "Balance")
        if #available(iOS 11.0, *) {
            navigationController!.navigationBar.prefersLargeTitles = true
        }

        setupNavigationBarButtons()
    
        // Load saved users.
        if let savedUsers = savedUsers() {
            users = savedUsers
        }
        
        // Update all data.
        refreshData()
        
        // Allow updating data.
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        // Cell setup.
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
    }
    
    private func setupNavigationBarButtons() {
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        let addViaCameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addViaCameraButtonTapped(_:)))
        let addViaTextButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addViaTextButtonTapped(_:)))
        self.navigationItem.rightBarButtonItems = [addViaTextButton, addViaCameraButton]
    }

    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.5 // 8 for margin, 50 for image, 8 for margin and 0.5 for table separator
    }

    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as? UserTableViewCell else {
            fatalError("The dequeued cell is not an instance of UserTableViewCell.")
        }

        let user = users[indexPath.row]
        
        cell.balanceLabel.text = "$\(user.balance)"
        cell.nameLabel.text = user.name
        cell.photoImageView.image = user.image
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            users.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        saveUsers()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let user = users[fromIndexPath.row]
        users.remove(at: fromIndexPath.row)
        users.insert(user, at: to.row)
    }
    
    // MARK: Actions
    @objc private func addViaTextButtonTapped(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: NSLocalizedString("balance.add.user.text.title", comment: "Add new user"),
                                   message: NSLocalizedString("balance.add.user.text.description", comment: "Type the barcode"),
                                   preferredStyle: .alert)

        ac.addTextField { textField in
            textField.enablesReturnKeyAutomatically = true
            textField.autocapitalizationType = .allCharacters
        }
        ac.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: "Cancel"), style: .cancel))
        ac.addAction(UIAlertAction(title: NSLocalizedString("balance.add.user.text.confirm", comment: "Add"), style: .default) { [unowned self, ac] _ in
            guard let text = ac.textFields!.first!.text?.uppercased() else { return }
            
            DispatchQueue.global(qos: .userInteractive).async {
                let user = User(fromCode: text)
                user.update {
                    self.add(user: user)
                }
            }
        })
        present(ac, animated: true)
    }
    
    @objc private func addViaCameraButtonTapped(_ sender: UIBarButtonItem) {
        let bsvc = BarcodeScannerViewController()
        bsvc.delegate = self

        navigationController?.pushViewController(bsvc, animated: true)
    }
    
    // MARK: Methods
    func add(user: User) {
        // Make sure it doesn't already exist.
        guard !users.contains(user) else {
            if #available(iOS 10.0, *) {
                os_log("User already exists.", log: .default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
            
            // TODO(alegre): Maybe alert the user?
            return
        }
        
        // Add a new user.
        DispatchQueue.main.async {
            let newIndexPath = IndexPath(row: self.users.count, section: 0)

            user.update()
            self.users.append(user)
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
            self.refreshData()
        }
    }
    
    private func saveUsers() {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(users)
            try data.write(to: User.ArchiveURL)
            if #available(iOS 10.0, *) {
                os_log("Users successfully saved.", log: .default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
        } catch {
            if #available(iOS 10.0, *) {
                os_log("Failed to save users...", log: .default, type: .error)
                print("Error: \(error).")
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    private func savedUsers() -> [User]? {
        let jsonDecoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: User.ArchiveURL)
            let users = try jsonDecoder.decode([User].self, from: data)
            return users
        } catch {
            if #available(iOS 10.0, *) {
                os_log("Failed to load users...", log: .default, type: .error)
                print("Error: \(error).")
            } else {
                // Fallback on earlier versions
            }
            return nil
        }
    }
    
    @objc private func refreshData(_ refreshControl: UIRefreshControl? = nil) {
        let queue = DispatchQueue(label: "usersRefreshing", attributes: .concurrent, target: .main)
        let group = DispatchGroup()
        
        for user in users {
            group.enter()
            queue.async(group: group) { user.update { group.leave() } }
        }
        
        group.notify(queue: queue) {
            self.tableView.reloadData()
            self.saveUsers()
            refreshControl?.endRefreshing()
        }
    }
}
