//
//  UserTableViewController.swift
//  UNCmorfi
//
//  Created by George Alegre on 4/25/17.
//  Copyright © 2017 George Alegre. All rights reserved.
//

import UIKit
import os.log

class UserTableViewController: UITableViewController {
    // MARK: Properties
    var users: [User] = [ User(code: "04756A29333c62D") ]
    private let cellID = "UserTableViewCell"

    // MARK: MVC life cycle.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        
        // Navigation setup
        title = "Balance"
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        // Load saved users
        if let savedUsers = loadUsers() {
            users += savedUsers
            refreshData()
        }
        
        // Allow pull-to-refresh
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    // MARK: Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? UserCell else {
//            fatalError("The dequeued cell is not an instance of UserCell.")
//        }
//
        let user = users[indexPath.row]
//
//        cell.selectionStyle = .none
//        cell.balanceLabel.text = "$\(user.balance)"
//        cell.nameLabel.text = user.name
//        cell.photoImageView.image = user.image
//        cell.photoImageView.layer.cornerRadius = 10
        
        let cell = UserCell(style: .default, reuseIdentifier: cellID)
        cell.imageView?.image = user.image
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            users.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
        
        saveUsers()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let user = users[fromIndexPath.row]
        users.remove(at: fromIndexPath.row)
        users.insert(user, at: to.row)
    }
    
    // MARK: Actions
    @IBAction func unwindToUserList(sender: UIStoryboardSegue) {
        func add(user: User) {
            // Make sure it doesn't already exist.
            if users.contains(user) {
                if #available(iOS 10.0, *) {
                    os_log("User already exists.", log: .default, type: .debug)
                } else {
                    // Fallback on earlier versions
                }
                
                // TODO(alegre): Maybe alert the user?
                return
            }
            
            // Add a new user.
            let newIndexPath = IndexPath(row: users.count, section: 0)
            
            self.users.append(user)
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
            self.refreshData()
        }
        
        if let svc = sender.source as? NewUserViewController, let user = svc.user {
            add(user: user)
        } else if let svc = sender.source as? BarcodeScannerViewController, let user = svc.user {
            add(user: user)
        }
    }
    
    // MARK: Methods
    private func saveUsers() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(users, toFile: User.ArchiveURL.path)
        if isSuccessfulSave {
            if #available(iOS 10.0, *) {
                os_log("Users successfully saved.", log: .default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
        } else {
            if #available(iOS 10.0, *) {
                os_log("Failed to save users...", log: .default, type: .error)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    private func loadUsers() -> [User]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? [User]
    }
    
    @objc private func refreshData(_ refreshControl: UIRefreshControl? = nil) {
        let queue = DispatchQueue(label: "usersRefreshing", attributes: .concurrent, target: .main)
        let group = DispatchGroup()
        
        users.forEach { user in
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
