//
//  TribeDetailViewController.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/22/21.
//

import UIKit

class TribeDetailViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var driverLabel: UILabel!
    @IBOutlet weak var passengersLabel: UILabel!
    
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
    @IBAction func startNavTapped(_ sender: Any) {
        //open route in google maps
        guard let tribe = tribe,
              let driver = driver else {return}
        
        createCarpoolRoute(from: tribe, with: driver, and: passengers)
    }
    
    // MARK: - Functions
    
    func fetchDriverAndPassengers() {
        guard let carpool = tribe else {return}
        destinationLabel.text = "Destination: \(carpool.destinationName)"
        CarpoolController.shared.fetchPassengersIn(carpool: carpool) { [weak self] (result) in
            switch result {
            case .success(let passengers):
                DispatchQueue.main.async {
                    self?.passengers = passengers
                    self?.passengersLabel.text = passengers[0].firstName
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
                    self?.driverLabel.text = "Driver: \(driver.firstName)"
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }//end func
}//end class
