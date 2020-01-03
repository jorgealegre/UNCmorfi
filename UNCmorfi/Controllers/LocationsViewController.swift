//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import UNCmorfiKit

class ComedorAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D

    init(fromComedor comedor: Comedor) {
        switch comedor {
        case .downtown:
            self.title = .downtown
        case .university:
            self.title = .university
        }
        
        self.coordinate = CLLocationCoordinate2D(latitude: comedor.location.latitude,
                                                 longitude: comedor.location.longitude)
    }
}

class LocationsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - Views
    
    private let mapView: MKMapView = {
        let mapView = MKMapView(frame: UIScreen.main.bounds)
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = true
        return mapView
    }()
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()

    // MARK: - Initializers

    init() {
        super.init(nibName: nil, bundle: nil)

        restorationIdentifier = "\(Self.self)"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View lifecycle
    
    override func loadView() {
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = .locations
        navigationController!.navigationBar.prefersLargeTitles = true

        if !Settings.capturingScreenshots {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        }
        
        mapView.delegate = self

        let annotations = Comedor.allCases.map(ComedorAnnotation.init)
        
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
        guard let annotation = annotation as? ComedorAnnotation else { return nil }
        
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        MKMapItem(placemark: MKPlacemark(coordinate: view.annotation!.coordinate)).openInMaps(launchOptions: nil)
    }
}
