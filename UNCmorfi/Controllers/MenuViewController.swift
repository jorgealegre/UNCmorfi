//
//  MenuViewController.swift
//  UNCmorfi
//
//  Created by George Alegre on 5/24/17.
//
//  LICENSE is at the root of this project's repository.
//

import UIKit

class MenuViewController: UITableViewController {

    // MARK: - Properties

    private var menu: [Date: [String]]?
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "EEEE d"
        return dateFormatter
    }()

    // MARK: - Views

    private let activityIndicator: UIActivityIndicatorView = {
        let view: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            view = UIActivityIndicatorView(style: .large)
        } else {
            view = UIActivityIndicatorView(style: .gray)
        }
        return view
    }()

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "menu.nav.label".localized()
        navigationController!.navigationBar.prefersLargeTitles = true
        
        tableView.backgroundView = activityIndicator
        activityIndicator.startAnimating()
        tableView.separatorStyle = .none
        tableView.register(FoodCell.self, forCellReuseIdentifier: FoodCell.reuseIdentifier)
    
        UNCComedor.shared.getMenu { apiResult in
            DispatchQueue.main.async { [unowned self] in
                self.activityIndicator.stopAnimating()
                switch apiResult {
                case .failure(_):
                    return
                case .success(let menu):
                    self.menu = menu.menu
                    
                    self.tableView?.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu?.keys.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: should move this code to FoodCell
        let cell = tableView.dequeueReusableCell(withIdentifier: FoodCell.reuseIdentifier, for: indexPath) as! FoodCell
        
        let date = menu!.keys.sorted()[indexPath.row]
        cell.dateLabel.text = dateFormatter.string(from: date)

        menu![date]!.enumerated().forEach{ index, meal in
            let label = cell.mealsStackView.arrangedSubviews[index] as! UILabel
            label.text = meal
        }
        
        return cell
    }
}
