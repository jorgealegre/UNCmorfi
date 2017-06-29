//
//  Comedor.swift
//  UNCmorfi
//
//  Created by George Alegre on 6/29/17.
//  Copyright © 2017 George Alegre. All rights reserved.
//

import Foundation
import MapKit

class Comedor: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
