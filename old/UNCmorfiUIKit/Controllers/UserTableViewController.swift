//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import UNCmorfiKit

class UserTableViewController: UITableViewController {

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Properties

    weak var navigator: UsersNavigator?

    private let feedbackGenerator = UINotificationFeedbackGenerator()

    // MARK: - Initializers

    init() {
        super.init(nibName: nil, bundle: nil)

        restorationIdentifier = "\(Self.self)"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = .balance
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

        let manualAction = UIAlertAction(title: .manual, style: .default, handler: addUserViaText)
        let cameraAction = UIAlertAction(title: .camera, style: .default, handler: addUserViaCamera)
        let photoAction = UIAlertAction(title: .photo, style: .default, handler: addUserViaPhoto)
        let cancelAction = UIAlertAction(title: .cancel, style: .cancel)

        alertController.addActions(manualAction, cameraAction, photoAction, cancelAction)
        present(alertController, animated: true)
    }

    private func addUserViaPhoto(_ action: UIAlertAction) {
        navigator?.navigate(to: .photoPicker)
    }

    private func addUserViaText(_ action: UIAlertAction) {
        let ac = UIAlertController(title: .addNewPerson, message: .typeBarcode, preferredStyle: .alert)

        ac.addTextField { textField in
            textField.enablesReturnKeyAutomatically = true
            textField.autocapitalizationType = .allCharacters
            textField.clearButtonMode = .whileEditing
        }
        ac.addAction(UIAlertAction(title: .cancel, style: .cancel))
        ac.addAction(UIAlertAction(title: .add, style: .default) { [ac] _ in
            guard let text = ac.textFields!.first!.text?.uppercased() else { return }

            self.addNewUser(withCode: text)
        })
        present(ac, animated: true)
    }
    
    private func addUserViaCamera(_ action: UIAlertAction) {
        navigator?.navigate(to: .barcodeScanner)
    }
    
    // MARK: - Methods

    private func addNewUser(withCode code: String) {
        feedbackGenerator.prepare()

        Services.userStore.addUser(withCode: code) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.tableView.reloadData()
                self.feedbackGenerator.notificationOccurred(.success)
            case let .failure(error):
                switch error {
                case .userNotFound:
                    let alert = UIAlertController(title: .userNotFound,
                                                  message: .codeProvidedDoesntMatchExistingUser,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: .ok, style: .default))
                    self.feedbackGenerator.notificationOccurred(.warning)
                    self.present(alert, animated: true)
                default:
                    self.feedbackGenerator.notificationOccurred(.error)
                }
            }
        }
    }
    
    @objc private func refreshData(_ refreshControl: UIRefreshControl? = nil) {
        guard !Services.userStore.users.isEmpty else {
            refreshControl?.endRefreshing()
            return
        }

        feedbackGenerator.prepare()
        Services.userStore.updateUsers { [unowned self] _ in
            self.usersUpdated()
            refreshControl?.endRefreshing()
            self.feedbackGenerator.notificationOccurred(.success)
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
