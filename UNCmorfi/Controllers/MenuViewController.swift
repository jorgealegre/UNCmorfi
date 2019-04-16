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
    private var menu: [Date: [String]]? = nil

    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "menu.nav.label".localized()
        if #available(iOS 11.0, *) {
            navigationController!.navigationBar.prefersLargeTitles = true
        }
        
        tableView.backgroundView = activityIndicator
        activityIndicator.startAnimating()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(FoodCell.self, forCellReuseIdentifier: FoodCell.reuseIdentifier)
    
        UNCComedor.api.getMenu { apiResult in
            DispatchQueue.main.async { [unowned self] in
                self.activityIndicator.stopAnimating()
                switch apiResult {
                case .failure(_):
                    return
                case .success(let menu):
                    self.menu = menu
                    
                    self.tableView?.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu?.keys.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return FoodCell.populate(tableView: tableView, menu: self.menu, indexPath: indexPath)
    }
}
