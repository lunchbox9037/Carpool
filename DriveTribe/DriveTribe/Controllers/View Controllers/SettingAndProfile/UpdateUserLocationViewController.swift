//
//  UpdateUserLocationViewController.swift
//  DriveTribe
//
//  Created by Lee on 3/30/21.
//
import UIKit
import MapKit
import CoreLocation
import FloatingPanel


class UpdateUserLocationViewController: UIViewController {
    
    
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    let panel = FloatingPanelController()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        let destinationSearchVC = UpdateUserLocationSearchViewController()
        destinationSearchVC.mapView = self.mapView
        destinationSearchVC.delegate = self
        panel.set(contentViewController: destinationSearchVC)
        panel.addPanel(toParent: self)
        panel.move(to: .tip, animated: false)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        //UPDATE LOCATION IN DATABASE
        print("\n===================UserController.shared.lastCurrentLocation :: \(UserController.shared.lastCurrentLocation)======================IN \(#function)\n")
        UserController.shared.updateUserLocation(lastCurrentLocation: UserController.shared.lastCurrentLocation) { [weak self] (results) in
            switch results {
            case .success(let lastCurrentLocation):
                print("\n===================lastCurrentLocation :: \(lastCurrentLocation)====================== IN\(#function)\n")
            case .failure(let error):
                print("\n===================ERROR! \(error.localizedDescription) IN\(#function) ======================\n")
            }
        }
    }
    
}//end class

extension UpdateUserLocationViewController: UpdateUserLocationSearchViewControllerDelegate {
    func searchViewController(_ vc: UpdateUserLocationSearchViewController, didSelectLocationWith mapItem: MKMapItem) {
        panel.move(to: .tip, animated: true)
        let coordinates = mapItem.placemark.coordinate
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        pin.title = mapItem.placemark.name
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)), animated: true)
    }
    
    
    func didBeginEditing() {
        panel.move(to: .full, animated: true)
    }
    
    func setCurrentLocation(location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        print(location)
    }
}

