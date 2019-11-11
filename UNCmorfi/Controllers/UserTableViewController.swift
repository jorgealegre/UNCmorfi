//
//  UserTableViewController.swift
//  UNCmorfi
//
//  Created by George Alegre on 4/25/17.
//
//  LICENSE is at the root of this project's repository.
//

import UIKit

class UserTableViewController: UITableViewController {

    // MARK: - Properties
    private var users: [User] = []

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "balance.nav.label".localized()
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
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseIdentifier)
    }
    
    private func setupNavigationBarButtons() {
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        let addViaCameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addViaCameraButtonTapped(_:)))
        let addViaTextButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addViaTextButtonTapped(_:)))
        self.navigationItem.rightBarButtonItems = [addViaTextButton, addViaCameraButton]
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.5 // 8 for margin, 50 for image, 8 for margin and 0.5 for table separator
    }

    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier, for: indexPath) as! UserCell

        let user = users[indexPath.row]
        
        cell.configureFor(user: user)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    
    // MARK: - Actions

    @objc private func addViaTextButtonTapped(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "balance.add.user.text.title".localized(),
                                   message: "balance.add.user.text.description".localized(),
                                   preferredStyle: .alert)

        ac.addTextField { textField in
            textField.enablesReturnKeyAutomatically = true
            textField.autocapitalizationType = .allCharacters
            textField.clearButtonMode = .whileEditing
        }
        ac.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel))
        ac.addAction(UIAlertAction(title: "balance.add.user.text.confirm".localized(), style: .default) { [unowned self, ac] _ in
            guard let text = ac.textFields!.first!.text?.uppercased() else { return }
            
            let user = User(fromCode: text)
            self.add(user: user)
        })
        present(ac, animated: true)
    }
    
    @objc private func addViaCameraButtonTapped(_ sender: UIBarButtonItem) {
        let bsvc = BarcodeScannerViewController()
        bsvc.delegate = self
        navigationController?.pushViewController(bsvc, animated: true)
    }
    
    // MARK: - Methods

    func add(user: User) {
        // Make sure it doesn't already exist.
        guard !users.contains(user) else {
            return
        }
        users.append(user)
        
        // Add a new user.
        users.update { users in
            DispatchQueue.main.async { [unowned self] in
                self.users = users
                self.tableView.reloadData()
                self.saveUsers()
            }
        }
    }
    
    private func saveUsers() {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(users)
            try data.write(to: User.archiveURL)
        } catch {
            print("Error: \(error).")
        }
    }
    
    private func savedUsers() -> [User]? {
        let jsonDecoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: User.archiveURL)
            let users = try jsonDecoder.decode([User].self, from: data)
            return users
        } catch {
            print("Error: \(error).")
            return nil
        }
    }
    
    @objc private func refreshData(_ refreshControl: UIRefreshControl? = nil) {
        users.update { (users) in
            DispatchQueue.main.async {
                self.users = users
                self.saveUsers()
                self.tableView.reloadData()
                refreshControl?.endRefreshing()
            }
        }
    }
}
