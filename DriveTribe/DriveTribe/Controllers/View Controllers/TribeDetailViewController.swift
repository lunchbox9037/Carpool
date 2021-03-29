//
//  TribeDetailViewController.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/22/21.
//

import UIKit

class TribeDetailViewController: UIViewController {
    // MARK: - Outlets
    
    // MARK: - Properties
    var tribe: Carpool?
    var driver: User?
    var passengers: [User] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDriverAndPassengers()
        setAppearance()
    }
    
    // MARK: - Actions
//    @IBAction func startNavTapped(_ sender: Any) {
//        //open route in google maps
//        guard let tribe = tribe,
//              let driver = driver else {return}
//
//        createCarpoolRoute(from: tribe, with: driver, and: passengers)
//    }
    
    // MARK: - Functions
    func fetchDriverAndPassengers() {
        guard let carpool = tribe else {return}
        CarpoolController.shared.fetchPassengersIn(carpool: carpool) { [weak self] (result) in
            switch result {
            case .success(let passengers):
                DispatchQueue.main.async {
                    self?.passengers = passengers
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        CarpoolController.shared.fetchDriverIn(carpool: carpool) { [weak self] (result) in
            switch result {
            case .success(let driver):
                DispatchQueue.main.async {
                    self?.driver = driver
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }//end func
}//end class
