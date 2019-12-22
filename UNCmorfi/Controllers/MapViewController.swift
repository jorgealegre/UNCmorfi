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
    
    // MARK: - Views
    
    private let mapView: MKMapView = {
        let mapView = MKMapView(frame: UIScreen.main.bounds)
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = true
        return mapView
    }()
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()
    
    private let viewID = "viewID"
    
    // MARK: - View lifecycle
    
    override func loadView() {
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "map.nav.label".localized()
        navigationController!.navigationBar.prefersLargeTitles = true
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        
        let uni = Comedor(
            title: "university.annotation.title".localized(),
            subtitle: nil,
            coordinate: CLLocationCoordinate2D(latitude: -31.439734, longitude: -64.189293))
        
        let downtown = Comedor(
            title: "downtown.annotation.title".localized(),
            subtitle: nil,
            coordinate: CLLocationCoordinate2D(latitude: -31.416686, longitude: -64.189000))
        
        let annotations = [uni, downtown]
        
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
        
        // Annotations appear hidden under navigation and tab bar controllers.
        // The view covers the whole screen so annotations DO appear but under these elements.
        // Increase viewing region by 50% (titles are bigger).
        // Shift map downwards just a bit.
        let zoomMultiplier = 1.5
        let center = mapView.region.center
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2DMake(center.latitude + 0.002, center.longitude),
            span: MKCoordinateSpan(
                latitudeDelta: mapView.region.span.latitudeDelta * zoomMultiplier,
                longitudeDelta: mapView.region.span.longitudeDelta * zoomMultiplier)
        )
        mapView.setRegion(region, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
        mapView.showsUserLocation = false
        super.viewWillDisappear(animated)
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    // MARK: - MKMapViewDelegate
    
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
        MKMapItem(placemark: MKPlacemark(coordinate: view.annotation!.coordinate)).openInMaps(launchOptions: nil)
    }
}
