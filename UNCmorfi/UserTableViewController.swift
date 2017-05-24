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
    var users: [User] = []
    let cellID = "UserTableViewCell"

    // MARK: MVC life cycle.
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedUsers = loadUsers() {
            users += savedUsers
        }
        
        refreshData()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? UserTableViewCell else {
            fatalError("The dequeued cell is not an instance of UserTableViewCell.")
        }

        let user = users[indexPath.row]
        
        cell.selectionStyle = .none
        cell.balanceLabel.text = "$\(user.balance)"
        cell.nameLabel.text = user.name
        cell.photoImageView.image = user.image
        cell.photoImageView.layer.cornerRadius = 10
        
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

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */
    
    // MARK: Actions
    @IBAction func unwindToUserList(sender: UIStoryboardSegue) {
        if let svc = sender.source as? NewUserViewController, let user = svc.user
        {
            // Make sure it doesn't already exist.
            if users.contains(user)
            {
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
        else if let svc = sender.source as? BarcodeScannerViewController, let user = svc.user
        {
            // Make sure it doesn't already exist.
            if users.contains(user)
            {
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
    
    private func loadUsers() -> [User]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? [User]
    }
    
    @objc private func refreshData(_ refreshControl: UIRefreshControl? = nil) {
        let queue = DispatchQueue(label: "usersRefreshing", attributes: .concurrent, target: .main)
        let group = DispatchGroup()
        
        for user in users
        {
            group.enter()
            queue.async(group: group) {
                user.update {
                    group.leave()
                }
            }
        }
        
        group.notify(queue: queue) {
            self.tableView.reloadData()
            self.saveUsers()
            refreshControl?.endRefreshing()
        }
    }
}
