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

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "balance.nav.label".localized()
        if #available(iOS 11.0, *) {
            navigationController!.navigationBar.prefersLargeTitles = true
        }
        
        setupNavigationBarButtons()
        
        // Update all data.
        refreshData()
        
        // Allow updating data.
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        // Cell setup.
        tableView.estimatedRowHeight = 65
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseIdentifier)
    }
    
    private func setupNavigationBarButtons() {
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addViaCameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self,
                                                 action: #selector(addViaCameraButtonTapped))
        let addViaTextButton = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                               action: #selector(addViaTextButtonTapped))
        navigationItem.rightBarButtonItems = [addViaTextButton, addViaCameraButton]
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserStore.shared.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier,
                                                 for: indexPath) as! UserCell

        let user = UserStore.shared.users[indexPath.row]
        
        cell.configureFor(user: user)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            UserStore.shared.removeUser(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        UserStore.shared.swapUser(from: fromIndexPath.row, to: to.row)
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

            self.addNewUser(withCode: text)
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

    private func addNewUser(withCode code: String) {
        UserStore.shared.addUser(withCode: code) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.tableView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    @objc private func refreshData(_ refreshControl: UIRefreshControl? = nil) {
        UserStore.shared.updateUsers { [unowned self] in
            self.tableView.reloadData()
            refreshControl?.endRefreshing()
        }
    }
}

extension UserTableViewController: BarcodeScannerViewControllerDelegate {
    func barcodeScanner(_ barcodeScannerViewController: BarcodeScannerViewController,
                        didScanCode code: String) {
        addNewUser(withCode: code)
    }
}
