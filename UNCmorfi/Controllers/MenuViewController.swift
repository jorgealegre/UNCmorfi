//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import UNCmorfiKit

class MenuViewController: UITableViewController {

    // MARK: - Properties

    private var menu: [Date: [String]]?

    private let feedbackGenerator = UINotificationFeedbackGenerator()

    // MARK: - Views

    private let activityIndicator: UIActivityIndicatorView = {
        let view: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            view = UIActivityIndicatorView(style: .large)
        } else {
            view = UIActivityIndicatorView(style: .gray)
        }
        view.accessibilityIdentifier = "activity-indicator"
        return view
    }()

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "menu.nav.label".localized()
        navigationController!.navigationBar.prefersLargeTitles = true
        
        tableView.backgroundView = activityIndicator
        tableView.separatorStyle = .none
        tableView.register(FoodCell.self, forCellReuseIdentifier: FoodCell.reuseIdentifier)

        activityIndicator.startAnimating()
        feedbackGenerator.prepare()
        URLSession.shared.load(.menu) { [weak self] result in
            guard let self = self else { return }

            self.activityIndicator.stopAnimating()

            switch result {
            case let .success(menu):
                self.menu = menu.menu
                self.tableView.reloadData()
                self.feedbackGenerator.notificationOccurred(.success)
            case let .failure(error):
                self.feedbackGenerator.notificationOccurred(.error)
                print(error)
            }
        }
    }

    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu?.keys.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FoodCell.reuseIdentifier, for: indexPath) as! FoodCell
        
        let date = menu!.keys.sorted()[indexPath.row]

        cell.configure(date: date, meals: menu![date]!)
        
        return cell
    }
}
