//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import FontAwesome

public enum TabBarIcon {
    case users
    case menu
    case servings
    case locations
    case information

    public var image: UIImage {
        // Standard tab bar item image size.
        let size = CGSize(width: 25, height: 25)

        switch self {
        case .users:
            return .fontAwesomeIcon(name: .idCard, style: .regular, textColor: .black, size: size)
        case .menu:
            return .fontAwesomeIcon(name: .utensils, style: .solid, textColor: .black, size: size)
        case .servings:
            return .fontAwesomeIcon(name: .tachometerAlt, style: .solid, textColor: .black, size: size)
        case .locations:
            return .fontAwesomeIcon(name: .map, style: .regular, textColor: .black, size: size)
        case .information:
            return .fontAwesomeIcon(name: .infoCircle, style: .solid, textColor: .black, size: size)
        }
    }
}
