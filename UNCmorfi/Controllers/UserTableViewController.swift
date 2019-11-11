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
        tableView.estimatedRowHeight = 65
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseIdentifier)
    }
    
    private func setupNavigationBarButtons() {
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        let addViaCameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addViaCameraButtonTapped(_:)))
        let addViaTextButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addViaTextButtonTapped(_:)))
        self.navigationItem.rightBarButtonItems = [addViaTextButton, addViaCameraButton]
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
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
            saveUsers()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        users.swapAt(fromIndexPath.row, to.row)
        saveUsers()
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
        ac.addAction(UIAlertAction(title: "balance.add.user.text.confirm".localized(), style: .default) { [ac] _ in
            guard let text = ac.textFields!.first!.text?.uppercased() else { return }
            
            let user = User(fromCode: text)
            self.addUser(user)
        })
        present(ac, animated: true)
    }
    
    @objc private func addViaCameraButtonTapped(_ sender: UIBarButtonItem) {
        let bsvc = BarcodeScannerViewController()
        let navigationController = UINavigationController(rootViewController: bsvc)
        bsvc.delegate = self
        present(navigationController, animated: true)
    }
    
    // MARK: - Methods

    private func addUser(_ user: User) {
        // Make sure it doesn't already exist.
        guard !users.contains(user) else { return }
        users.append(user)

        refreshData()
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
        users.update { [unowned self] users in
            self.users = users
            self.saveUsers()
            self.tableView.reloadData()
            refreshControl?.endRefreshing()
        }
    }
}

extension UserTableViewController: BarcodeScannerViewControllerDelegate {
    func barcodeScanner(_ barcodeScannerViewController: BarcodeScannerViewController, didScanCode code: String) {
        let user = User(fromCode: code)
        addUser(user)
    }
}
