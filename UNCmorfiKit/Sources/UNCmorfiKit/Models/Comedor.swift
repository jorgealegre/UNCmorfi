//
// Copyright © 2019 George Alegre. All rights reserved.
//

import Foundation

public enum Comedor: CaseIterable {
    case university
    case downtown

    public var name: String {
        switch self {
        case .university: return "university.annotation.title"
        case .downtown: return "downtown.annotation.title"
        }
    }

    public var location: (latitude: Double, longitude: Double) {
        switch self {
        case .university: return (latitude: -31.439734, longitude: -64.189293)
        case .downtown: return (latitude: -31.416686, longitude: -64.189000)
        }
    }
}
