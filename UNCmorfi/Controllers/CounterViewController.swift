//
//  CouterViewController.swift
//  UNCmorfi
//
//  Created by George Alegre on 9/10/17.
//
//  LICENSE is at the root of this project's repository.
//

import UIKit

class CounterViewController: UIViewController {
    private var activityIndicator: UIActivityIndicatorView! = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        return view
    }()
    private var servingsLabel: UILabel! = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(14)
        label.numberOfLines = 0
        return label
    }()

    private var servings: [Date: Int]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = NSLocalizedString("counter.nav.label", comment: "Counter")

        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()

        UNCComedor.getServings { (error: Error?, servings: [Date : Int]?) in
            guard error == nil else {
                // TODO this is temporary
                self.servingsLabel.text = "Hubo un problema. Intente de nuevo."
                return
            }

            self.servings = servings
            DispatchQueue.main.async { self.setupViews() }
        }
    }

    private func setupViews() {
        view.addSubview(servingsLabel)
        servingsLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        servingsLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        let standardSpacing: CGFloat = 8.0
        servingsLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing).isActive = true
        servingsLabel.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -standardSpacing).isActive = true

        activityIndicator.stopAnimating()

        servingsLabel.text = servings!.keys.sorted().reduce(0) { (count, date) -> Int in
            return count + servings![date]!
        }.description
    }
}
