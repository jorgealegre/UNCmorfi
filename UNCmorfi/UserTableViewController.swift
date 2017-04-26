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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedUsers = loadUsers() {
            users += savedUsers
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
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
        
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            users.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
            if users.contains(user) {
                os_log("User already exists.", log: .default, type: .debug)
                
                // TODO(alegre): Maybe alert the user?
                return
            }
            
            // Add a new user.
            let newIndexPath = IndexPath(row: users.count, section: 0)
            
            user.update() {
                self.users.append(user)
                self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                self.saveUsers()
            }
        }
    }
    
    // MARK: Methods
    private func saveUsers() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(users, toFile: User.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Users successfully saved.", log: .default, type: .debug)
        } else {
            os_log("Failed to save users...", log: .default, type: .error)
        }
    }
    
    private func loadUsers() -> [User]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? [User]
    }
}
