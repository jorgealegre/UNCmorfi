//
//  String+Localized.swift
//  UNCmorfi
//
//  Created by George Alegre on 28/09/2017.
//  Copyright © 2017 George Alegre. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, value: "**\(self)**", comment: "")
    }
}
