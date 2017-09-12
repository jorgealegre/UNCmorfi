//
//  MenuViewController.swift
//  UNCmorfi
//
//  Created by George Alegre on 5/24/17.
//
//  LICENSE is at the root of this project's repository.
//

import UIKit

class MenuViewController: UIViewController {
    private var activityIndicator: UIActivityIndicatorView! = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        return view
    }()
    private var menuLabel: UILabel! = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(14)
        label.numberOfLines = 0
        return label
    }()
    
    private var menu: [Date: [String]]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = NSLocalizedString("menu.nav.label", comment: "Menu")

        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()

        UNCComedor.getMenu { (error: Error?, menu: [Date : [String]]?) in
            guard error == nil else {
                // TODO this is temporary
                self.menuLabel.text = "Hubo un problema. Intente de nuevo."
                return
            }
            
            self.menu = menu
            DispatchQueue.main.async { self.setupViews() }
        }
    }
    
    private func setupViews() {
        view.addSubview(menuLabel)
        menuLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        menuLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        let standardSpacing: CGFloat = 8.0
        menuLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing).isActive = true
        menuLabel.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -standardSpacing).isActive = true

        activityIndicator.stopAnimating()

        menuLabel.text = menu?.keys.sorted().reduce("") { (text: String, date: Date) -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE d"
            
            let dateDescription = dateFormatter.string(from: date)
            let foodDescription = menu?[date]!.joined(separator: "\n") ?? ""
            return text.appending("\(dateDescription):\n\(foodDescription)\n\n")
            }.trimmingCharacters(in: .whitespaces)
    }
}
