//
//  UserLocationSearchViewController.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/22/21.
//

import UIKit
import CoreLocation
import MapKit

protocol UserLocationSearchViewControllerDelegate: AnyObject {
    func didBeginEditing()
    func setCurrentLocation(location: CLLocation)
    func searchViewController(_ vc: UserLocationSearchViewController, didSelectLocationWith mapItem: MKMapItem)
}

class UserLocationSearchViewController: UIViewController {
    // MARK: - Properties
    fileprivate let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var searchResults: [MKMapItem] = []

    weak var mapView: MKMapView?
    weak var delegate: UserLocationSearchViewControllerDelegate?
    
    // MARK: - Views
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Whats your current location?"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        
        return label
    }()
    
    private let field: UITextField = {
        let field  = UITextField()
        field.placeholder = " Enter location..."
        field.layer.cornerRadius = 8
        field.backgroundColor = .tertiarySystemBackground
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.autocorrectionType = .no
        field.returnKeyType = .go
        
        return field
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "destinationCell")
        tableView.backgroundColor = .secondarySystemBackground
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getCurrentLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: 10, y: 20, width: label.frame.size.width, height: label.frame.size.height)
        field.frame = CGRect(x: 10, y: 30+label.frame.size.height, width: view.frame.size.width-20, height: 44)
        let tableY: CGFloat = field.frame.origin.y+field.frame.size.height+5
        tableView.frame = CGRect(x: 0, y: tableY, width: view.frame.size.width, height: view.frame.size.height-tableY)
    }
    
    // MARK: - Methods
    func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(label)
        view.addSubview(field)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        field.delegate = self
    }
    
    func getCurrentLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - UITableView Extension
extension UserLocationSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "destinationCell", for: indexPath)
        cell.backgroundColor = .secondarySystemBackground
        cell.contentView.backgroundColor = .secondarySystemBackground
        cell.textLabel?.numberOfLines = 0
        
        let placeMark = searchResults[indexPath.row].placemark
        var address: String = ""
        if let name = placeMark.name {
            address += "\(name)"
        }
        
        if let street = placeMark.thoroughfare {
            address += ", \(street)"
        }
        
        if let city = placeMark.locality {
            address += ", \(city)"
        }
        
        if let zip = placeMark.postalCode {
            address += ", \(zip)"
        }

        cell.textLabel?.text = address
        cell.imageView?.image = UIImage(systemName: "building.2.crop.circle")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation = searchResults[indexPath.row]
        let userLocation = selectedLocation.placemark.coordinate
        UserController.shared.lastCurrentLocation = []
        UserController.shared.lastCurrentLocation.append(userLocation.latitude)
        UserController.shared.lastCurrentLocation.append(userLocation.longitude)

        delegate?.searchViewController(self, didSelectLocationWith: selectedLocation)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITextField extension
extension UserLocationSearchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.didBeginEditing()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        field.resignFirstResponder()
        if let text = field.text, !text.isEmpty,
           let mapview = self.mapView {
            let searchRequest = MKLocalSearch.Request()
            searchRequest.region = mapview.region
            searchRequest.naturalLanguageQuery = text
            
            let search = MKLocalSearch(request: searchRequest)
            search.start { (response, error) in
                guard let response =  response else {
                    print(error?.localizedDescription ?? "unknown error")
                    return
                }
                DispatchQueue.main.async {
                    self.searchResults = response.mapItems
                    self.tableView.reloadData()
                }
            }
        }
        return true
    }
}

// MARK: - CLLocationManager extension
extension UserLocationSearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return}
        let userLocation = location.coordinate
        UserController.shared.lastCurrentLocation = []
        UserController.shared.lastCurrentLocation.append(userLocation.latitude)
        UserController.shared.lastCurrentLocation.append(userLocation.longitude)
        
        locationManager.stopUpdatingLocation()
        delegate?.setCurrentLocation(location: location)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus != .authorizedWhenInUse {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed to get location")
    }
}
