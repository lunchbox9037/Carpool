//
//  AddPassengerViewController.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/17/21.
//

import UIKit
import MapKit
import CoreLocation

struct User {
    let name: String
    let location: CLLocationCoordinate2D
}

class AddPassengerViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var passengerCollectionView: UICollectionView!
    
    // MARK: - Properties
    var passengerMockData: [User] = [
        User(name: "Lee", location: CLLocationCoordinate2D(latitude: 37.745700, longitude: -122.435251)),
        User(name: "Dennis", location: CLLocationCoordinate2D(latitude: 37.751836, longitude: -122.431316)),
        User(name: "Max", location: CLLocationCoordinate2D(latitude: 37.747651, longitude: -122.436914))
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    // MARK: - Actions
    @IBAction func saveCarpoolButtonTapped(_ sender: Any) {
        CarpoolController.shared.createCarpool()
//        guard let vc = UIStoryboard(name: "Carpool", bundle: nil).instantiateViewController(withIdentifier: "carpoolList") as? CarpoolListViewController else {return}
//        present(vc, animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
    }//end func
    
    // MARK: - Methods
    func setupCollectionView() {
        passengerCollectionView.collectionViewLayout = makeLayout()
        passengerCollectionView.backgroundColor = UIColor.systemFill

        passengerCollectionView.delegate = self
        passengerCollectionView.dataSource = self
        passengerCollectionView.isPrefetchingEnabled = true
        passengerCollectionView.register(PassengerCollectionViewCell.self, forCellWithReuseIdentifier: "passengerCell")
        passengerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        passengerCollectionView.reloadData()
    }//end func
    
    func makeLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            return LayoutBuilder.buildMediaVerticalScrollLayout()
        }
    }//end func
}//end class

// MARK: - Collectionview DataSource and Delegate extension
extension AddPassengerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return passengerMockData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = passengerCollectionView.dequeueReusableCell(withReuseIdentifier: "passengerCell", for: indexPath) as? PassengerCollectionViewCell else {return UICollectionViewCell()}
        cell.configure(passenger: passengerMockData[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        CarpoolController.shared.stops.append(passengerMockData[indexPath.row].location)
        collectionView.cellForItem(at: indexPath)?.backgroundColor = .systemGreen
    }
}//end extension
