//
//  Carpool.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/16/21.
//

import Foundation
import MapKit

class Carpool {
    let title: String
    let destination: MKPlacemark
    let stops: [MKPlacemark]
    let driver: String
    let passengers: [String]
    
    init(title: String, destination: MKPlacemark, stops: [MKPlacemark], driver: String, passengers: [String]) {
        self.title = title
        self.destination = destination
        self.stops = stops
        self.driver = driver
        self.passengers = passengers
    }
}
