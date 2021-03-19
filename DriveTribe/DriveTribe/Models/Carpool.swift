//
//  Carpool.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/16/21.
//

import Foundation
import MapKit
import CoreLocation

class Carpool {
    var title: String
    var type: String
    var destination: MKMapItem
    var stops: [CLLocationCoordinate2D]
    var driver: String
    var passengers: [String]
    var uuid: String
    
    init(title: String, type: String, destination: MKMapItem, stops: [CLLocationCoordinate2D], driver: String, passengers: [String], uuid: String = UUID().uuidString) {
        self.title = title
        self.type = type
        self.destination = destination
        self.stops = stops
        self.driver = driver
        self.passengers = passengers
        self.uuid = uuid
    }
}
