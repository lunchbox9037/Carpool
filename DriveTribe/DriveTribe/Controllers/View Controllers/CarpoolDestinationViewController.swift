//
//  CarpoolDestinationViewController.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/16/21.
//

import UIKit
import MapKit
import CoreLocation
import FloatingPanel

class CarpoolDestinationViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    let panel = FloatingPanelController()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let destinationSearchVC = DestinationSearchViewController()
        destinationSearchVC.delegate = self
        panel.set(contentViewController: destinationSearchVC)
        panel.addPanel(toParent: self)
        panel.move(to: .half, animated: false)
    }
}

extension CarpoolDestinationViewController: DestinationSearchViewControllerDelegate{
    func setCurrentLocation(location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
//        locManager.stopUpdatingLocation()
        print(location)
    }
    
    func didBeginEditing() {
        print("ran this")
        panel.move(to: .full, animated: true)
    }
    
    func searchViewController(_ vc: DestinationSearchViewController, didSelectLocationWith mapItem: MKMapItem) {
        //update mapview here
        panel.move(to: .tip, animated: true)
        let coordinates = mapItem.placemark.coordinate
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        pin.title = mapItem.placemark.name
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)), animated: true)
    }
}
