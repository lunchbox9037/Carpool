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
    @IBOutlet weak var passengersLabel: UILabel!
    
    // MARK: - Properties
    var tribe: Carpool?
    var driver: User?
    var passengers: [User] = []
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func startNavTapped(_ sender: Any) {
        //open route in google maps
    }
    
    // MARK: - Functions
    
    //fetchDriver
    //fetchPassengers
}
