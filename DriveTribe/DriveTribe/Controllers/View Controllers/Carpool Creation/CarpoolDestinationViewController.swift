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
        self.tabBarController?.tabBar.isHidden = true
        setAppearance()
        
        let destinationSearchVC = DestinationSearchViewController()
        destinationSearchVC.delegate = self
        destinationSearchVC.mapView = self.mapView
        
        panel.set(contentViewController: destinationSearchVC)
        panel.addPanel(toParent: self)
        panel.move(to: .tip, animated: false)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard CarpoolController.shared.destination != nil else {
            presentAlertToUser(titleAlert: "Whoops", messageAlert: "Please select a destination!")
            return false
        }
        return true
    }
}

extension CarpoolDestinationViewController: DestinationSearchViewControllerDelegate{
    func setCurrentLocation(location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        print(location)
    }
    
    func didBeginEditing() {
        panel.move(to: .full, animated: true)
    }
    
    func searchViewController(_ vc: DestinationSearchViewController, didSelectLocationWith mapItem: MKMapItem) {
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
