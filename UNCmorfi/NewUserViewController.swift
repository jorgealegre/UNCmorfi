//
//  NewUserViewController.swift
//  UNCmorfi
//
//  Created by George Alegre on 4/25/17.
//  Copyright © 2017 George Alegre. All rights reserved.
//

import UIKit
import os.log

class NewUserViewController: UIViewController, UITextFieldDelegate {
    // MARK: Properties
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        codeTextField.delegate = self
        
        updateSaveButtonState()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    // MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let code = codeTextField.text!
        
        // Create the new user to be added to the user table view.
        user = User(code: code)
    }
    
    // MARK: Private methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = codeTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}
