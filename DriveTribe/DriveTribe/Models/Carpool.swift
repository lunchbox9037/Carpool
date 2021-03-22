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




/*
import Foundation
import Firebase

struct CarpoolConstants  {
    static let titleKey = "title"
    static let typeKey = "type"
    static let destinationKey = "destination"
    static let stopsKey = "stops"
    static let driverKey = "driver"
    static let passengersKey = "passengers"
    static let uuidKey = "uuid"
}

class Carpool {
    var title: String
    var type: String
    var destination: [Double]
    var stops: [[Double]]
    var driver: String
    var passengers: [String]
    var uuid: String
    
    internal init(title: String = "Test Title", type: String = "play", destination: [Double] = [], stops: [[Double]] = [], driver: String = "driver", passengers: [String] = [], uuid: String = UUID().uuidString) {
        self.title = title
        self.type = type
        self.destination = destination
        self.stops = stops
        self.driver = driver
        self.passengers = passengers
        self.uuid = uuid
    }
    
    convenience init?(document: DocumentSnapshot) {
        guard let title = document[CarpoolConstants.titleKey] as? String,
              let type = document[CarpoolConstants.typeKey] as? String,
              let destination = document[CarpoolConstants.destinationKey] as? [Double],
              let stops = document[CarpoolConstants.stopsKey] as? [[Double]],
              let driver = document[CarpoolConstants.driverKey] as? String,
              let passengers = document[CarpoolConstants.passengersKey] as? [String],
              let uuid = document[CarpoolConstants.uuidKey] as? String else {return nil}
        
        self.init(title: title, type: type, destination: destination, stops: stops, driver: driver, passengers: passengers, uuid: uuid)
    }
}


extension Carpool: Equatable {
    static func == (lhs: Carpool, rhs: Carpool) -> Bool {
        return rhs.uuid == lhs.uuid
    }
}//End of extension
*/
