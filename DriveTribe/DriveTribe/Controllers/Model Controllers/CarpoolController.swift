//
//  CarpoolController.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/16/21.
//

import Foundation
import MapKit

class CarpoolController {
    // MARK: - Properties
    static let shared = CarpoolController()
    var carpools: [Carpool] = []
    
    // MARK: - CRUD
    func createCarpool(title: String, destination: MKPlacemark, stops: [MKPlacemark], driver: String, passengers: [String]) {
        let newCarpool = Carpool(title: title, destination: destination, stops: stops, driver: driver, passengers: passengers)
        carpools.append(newCarpool)
    }
    
    
    
}
