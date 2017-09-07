//
//  MapViewController.swift
//  UNCmorfi
//
//  Created by George Alegre on 6/29/17.
//
//  LICENSE is at the root of this project's repository.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var mapView: MKMapView! = {
        let mapView = MKMapView(frame: UIScreen.main.bounds)
        mapView.showsPointsOfInterest = true
        return mapView
    }()

    private let locationManager: CLLocationManager! = {
        let locationManager = CLLocationManager()
        return locationManager
    }()

    private let viewID = "viewID"

    override func loadView() {
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        mapView.delegate = self
        
        let uni = Comedor(title: "Ciudad Universitaria", subtitle: "Comedor en la ciudad universitaria.", coordinate: CLLocationCoordinate2D(latitude: -31.439734, longitude: -64.189293))
        let downtown = Comedor(title: "Centro", subtitle: "Comedor universitario en el centro.", coordinate: CLLocationCoordinate2D(latitude: -31.416686, longitude: -64.189000))
        let annotations = [uni, downtown]
        
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Comedor else { return nil }
        
        let annotationView: MKPinAnnotationView
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: viewID) as? MKPinAnnotationView {
            annotationView = view
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: viewID)
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if #available(iOS 10.0, *) {
            MKMapItem(placemark: MKPlacemark(coordinate: view.annotation!.coordinate)).openInMaps(launchOptions: nil)
        } else {
            // Fallback on earlier versions
        }
    }
}
