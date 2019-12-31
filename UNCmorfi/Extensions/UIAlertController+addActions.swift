//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit

extension UIAlertController {
    func addActions(_ actions: UIAlertAction...) {
        actions.forEach(addAction)
    }
}
