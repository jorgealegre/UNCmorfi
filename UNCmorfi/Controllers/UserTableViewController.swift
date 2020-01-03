//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import UNCmorfiKit

class UserTableViewController: UITableViewController {

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "balance.nav.label".localized()
        navigationController!.navigationBar.prefersLargeTitles = true

        setupNavigationBarButtons()
        
        // Allow updating data.
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        // Cell setup.
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseID)

        // Listen to notifications.
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(usersUpdated),
                                               name: .usersUpdated, object: nil)

        // Update all data.
        refreshData()
    }

    @objc private func applicationWillEnterForeground() {
        Services.userStore.reloadUsers()

        DispatchQueue.main.async {
            self.usersUpdated()
        }
    }
    
    private func setupNavigationBarButtons() {
        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.accessibilityIdentifier = "edit-button"

        let addUserButton = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                               action: #selector(addUserButtonTapped))
        addUserButton.accessibilityIdentifier = "add-button"
        navigationItem.rightBarButtonItem = addUserButton
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Services.userStore.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseID,
                                                 for: indexPath) as! UserCell

        let user = Services.userStore.users[indexPath.row]
        
        cell.configureFor(user: user)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Services.userStore.removeUser(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        Services.userStore.swapUser(from: fromIndexPath.row, to: to.row)
    }
    
    // MARK: - Actions

    @objc private func addUserButtonTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let manualAction = UIAlertAction(title: "manual".localized(), style: .default, handler: addUserViaText)
        let cameraAction = UIAlertAction(title: "camera".localized(), style: .default, handler: addUserViaCamera)
        let photoAction = UIAlertAction(title: "photo".localized(), style: .default, handler: addUserViaPhoto)
        let cancelAction = UIAlertAction(title: "cancel".localized(), style: .cancel)

        alertController.addActions(manualAction, cameraAction, photoAction, cancelAction)
        present(alertController, animated: true)
    }

    private func addUserViaPhoto(_ action: UIAlertAction) {
        if PhotoBarcodeScannerViewController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = PhotoBarcodeScannerViewController()
            imagePickerController.barcodeHandler = self
            present(imagePickerController, animated: true)
        }
    }

    private func addUserViaText(_ action: UIAlertAction) {
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
    
    private func addUserViaCamera(_ action: UIAlertAction) {
        let bsvc = CameraBarcodeScannerViewController()
        let navigationController = UINavigationController(rootViewController: bsvc)
        bsvc.barcodeHandler = self
        present(navigationController, animated: true)
    }
    
    // MARK: - Methods

    private func addNewUser(withCode code: String) {
        Services.userStore.addUser(withCode: code) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.tableView.reloadData()
            case let .failure(error):
                switch error {
                case .userNotFound:
                    let alert = UIAlertController(title: "user.not.found.title".localized(),
                                                  message: "user.not.found.message".localized(),
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ok".localized(), style: .default))
                    self.present(alert, animated: true)
                default:
                    break
                }
            }
        }
    }
    
    @objc private func refreshData(_ refreshControl: UIRefreshControl? = nil) {
        Services.userStore.updateUsers { [unowned self] _ in
            self.usersUpdated()
            refreshControl?.endRefreshing()
        }
    }

    @objc private func usersUpdated() {
        tableView.reloadData()
    }
}

extension UserTableViewController: BarcodeHandler {
    func barcodeDetected(_ barcode: String) {
        addNewUser(withCode: barcode)
    }
}
