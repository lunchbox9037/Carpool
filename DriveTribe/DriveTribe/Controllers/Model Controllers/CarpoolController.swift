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
    
    var destination: MKMapItem?
    var stops: [CLLocationCoordinate2D] = []
    var passengers: [String] = []
    var driver: String = "Current user name"
    var title: String = "Test"
    var type: String = "work"
    
    // MARK: - CRUD
    func createCarpool() {
        guard let destination = self.destination else {return}
        
        let newCarpool = Carpool(title: title, type: type, destination: destination, stops: stops, driver: driver, passengers: passengers)
        
        carpools.append(newCarpool)
        stops = []
    }
}
