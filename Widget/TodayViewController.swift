//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import NotificationCenter
import Alamofire

@objc(TodayViewController)
class TodayViewController: UITableViewController, NCWidgetProviding {

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Allow loading images from the server.
        DataRequest.addAcceptableImageContentTypes(["application/octet-stream"])

        // Configuration
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded

        // Table view configuration
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseID)
        tableView.rowHeight = 40
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserStore.shared.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseID, for: indexPath) as! UserCell

        let user = UserStore.shared.users[indexPath.row]

        cell.configureFor(user: user)

        return cell
    }

    // MARK: - NCWidgetProviding

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
      let expanded = activeDisplayMode == .expanded
      preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 200) : maxSize
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Maybe the users we're displaying are out of date.
        // Read latest users from disk.
        UserStore.shared.reloadUsers()
        tableView.reloadData()

        // Try to refresh the users we have.
        UserStore.shared.updateUsers { [unowned self] _ in
            self.tableView.reloadData()
            completionHandler(NCUpdateResult.newData)
        }
    }
}
