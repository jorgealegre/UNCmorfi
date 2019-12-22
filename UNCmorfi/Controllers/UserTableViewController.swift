//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: AppRunCount
    private var appRunCount: AppRunCount = AppRunCountImpl()

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

        // Update all data.
        refreshData()

        // Check count to request review
        checkForReview()
    }

    @objc private func applicationWillEnterForeground() {
        UserStore.shared.reloadUsers()

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setupNavigationBarButtons() {
        navigationItem.leftBarButtonItem = editButtonItem

        let addUserButton = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                               action: #selector(addUserButtonTapped))
        navigationItem.rightBarButtonItem = addUserButton
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserStore.shared.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseID,
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

    @objc private func addUserButtonTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "manual".localized(), style: .default, handler: { _ in
            self.addUserViaText()
        }))
        alertController.addAction(UIAlertAction(title: "camera".localized(), style: .default, handler: { _ in
            self.addUserViaCamera()
        }))
        alertController.addAction(UIAlertAction(title: "photo".localized(), style: .default, handler: { _ in
            self.addUserViaPhoto()
        }))
        alertController.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel))
        present(alertController, animated: true)
    }

    private func addUserViaPhoto() {
        if PhotoBarcodeScannerViewController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = PhotoBarcodeScannerViewController()
            imagePickerController.barcodeHandler = self
            present(imagePickerController, animated: true)
        }
    }

    private func addUserViaText() {
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
    
    private func addUserViaCamera() {
        let bsvc = CameraBarcodeScannerViewController()
        let navigationController = UINavigationController(rootViewController: bsvc)
        bsvc.barcodeHandler = self
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
        UserStore.shared.updateUsers { [unowned self] _ in
            self.tableView.reloadData()
            refreshControl?.endRefreshing()
        }
    }

    private func checkForReview() {
        if (appRunCount.reachedLimit)  {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
                appRunCount.reset()
            }
        }
    }
}

extension UserTableViewController: BarcodeHandler {
    func barcodeDetected(_ barcode: String) {
        addNewUser(withCode: barcode)
    }
}
