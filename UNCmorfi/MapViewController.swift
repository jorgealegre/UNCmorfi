//
//  MapViewController.swift
//  UNCmorfi
//
//  Created by George Alegre on 6/29/17.
//  Copyright © 2017 George Alegre. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
     
        let uni = Comedor(title: "Ciudad Universitaria", subtitle: "Comedor en la ciudad universitaria.", coordinate: CLLocationCoordinate2D(latitude: -31.439734, longitude: -64.189293))
        let downtown = Comedor(title: "Centro", subtitle: "Comedor universitario en el centro.", coordinate: CLLocationCoordinate2D(latitude: -31.416686, longitude: -64.189000))
        let annotations = [uni, downtown]
        
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
    }
}
