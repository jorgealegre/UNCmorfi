//
//  MenuViewController.swift
//  UNCmorfi
//
//  Created by George Alegre on 5/24/17.
//  Copyright © 2017 George Alegre. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    let menuText: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        return textView
    }()
    
    var menu : [Date:[String]]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNCComedor.getMenu { (error: Error?, menu: [Date : [String]]?) in
            guard error == nil else {
                print("OMG there's an error.")
                return
            }
            
            self.menu = menu
            
            DispatchQueue.main.async {
                self.setupViews()
            }
        }
    }
    
    func setupViews() {
        menuText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuText)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": menuText]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": menuText]))
        
        menuText.text = menu?.keys.sorted().reduce("El menú es:\n") { (text: String, date: Date) -> String in
            let foodDescription = menu?[date]!.joined(separator: "\n") ?? ""
            return text.appending("\(date.description): \(foodDescription)\n")
        }
    }
}
