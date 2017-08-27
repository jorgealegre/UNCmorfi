//
//  MenuViewController.swift
//  UNCmorfi
//
//  Created by George Alegre on 5/24/17.
//  Copyright © 2017 George Alegre. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var menuLabel: UILabel!
    
   var menu : [Date: [String]]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "El menú es:"
        menuLabel.text = ""
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
    
    func setupViews() {
        activityIndicator.stopAnimating()
        
        menuLabel.text = menu?.keys.sorted().reduce("") { (text: String, date: Date) -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE d"
            
            let dateDescription = dateFormatter.string(from: date)
            let foodDescription = menu?[date]!.joined(separator: "\n") ?? ""
            return text.appending("\(dateDescription): \(foodDescription)\n")
        }
    }
}
