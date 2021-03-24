//
//  UserLocationViewController.swift
//  DriveTribe
//
//  Created by Lee McCormick on 3/22/21.
//


import UIKit
import MapKit
import CoreLocation
import FloatingPanel

class UserLocationViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    let panel = FloatingPanelController()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        let destinationSearchVC = UserLocationSearchViewController()
        destinationSearchVC.mapView = self.mapView
        destinationSearchVC.delegate = self
        panel.set(contentViewController: destinationSearchVC)
        panel.addPanel(toParent: self)
        panel.move(to: .tip, animated: false)
    }
}//end class

extension UserLocationViewController: UserLocationSearchViewControllerDelegate {
    func setCurrentLocation(location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        print(location)
    }
    
    func didBeginEditing() {
        panel.move(to: .full, animated: true)
    }
    
    func searchViewController(_ vc: UserLocationSearchViewController, didSelectLocationWith mapItem: MKMapItem) {
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

