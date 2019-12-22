//
// Copyright © 2019 George Alegre. All rights reserved.
//

import Foundation

protocol BarcodeHandler: AnyObject {
    func barcodeDetected(_ barcode: String)
}
