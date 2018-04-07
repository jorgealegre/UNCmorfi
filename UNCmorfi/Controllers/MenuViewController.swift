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
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE d"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "menu.nav.label".localized()
        if #available(iOS 11.0, *) {
            navigationController!.navigationBar.prefersLargeTitles = true
        }
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(FoodCell.self, forCellReuseIdentifier: FoodCell.reuseIdentifier)
    
        UNCComedor.api.getMenu { apiResult in
            DispatchQueue.main.async { [unowned self] in
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
        // TODO: should move this code to FoodCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FoodCell.reuseIdentifier, for: indexPath) as? FoodCell else {
            fatalError("Dequeued cell is not a FoodCell.")
        }
        
        let date = menu!.keys.sorted()[indexPath.row]
        cell.dateLabel.text = dateFormatter.string(from: date)
        
        menu![date]!.enumerated().forEach{ index, meal in
            guard let label = cell.mealsStackView.arrangedSubviews[index] as? UILabel else {
                fatalError("Todo mal")
            }
            
            label.text = meal
        }
        
        return cell
    }
}
