//
// Copyright © 2019 George Alegre. All rights reserved.
//

import Foundation

public extension NumberFormatter {
    static let balanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "ARS"
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        return formatter
    }()
}
