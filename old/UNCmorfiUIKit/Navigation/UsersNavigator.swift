//
// Copyright © 2020 George Alegre. All rights reserved.
//

import UIKit

class UsersNavigator: Navigator {

    enum Destination {
        case barcodeScanner
        case photoPicker
    }

    private let usersViewController: UserTableViewController

    init(usersViewController: UserTableViewController) {
        self.usersViewController = usersViewController
    }

    func navigate(to destination: Destination) {
        switch destination {
        case .barcodeScanner:
            let bsvc = CameraBarcodeScannerViewController()
            let navigationController = UINavigationController(rootViewController: bsvc)
            bsvc.barcodeHandler = usersViewController
            usersViewController.present(navigationController, animated: true)
        case .photoPicker:
            if PhotoBarcodeScannerViewController.isSourceTypeAvailable(.photoLibrary) {
                let imagePickerController = PhotoBarcodeScannerViewController()
                imagePickerController.barcodeHandler = usersViewController
                usersViewController.present(imagePickerController, animated: true)
            }
        }
    }
}
