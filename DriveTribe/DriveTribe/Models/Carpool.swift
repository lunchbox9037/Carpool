//
//  Carpool.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/16/21.
//

//import Foundation
//import MapKit
//import CoreLocation
//
//class Carpool {
//    var title: String
//    var mode: String
//    var type: String
//    var destinationName: String
//    var destination: [Double]
//    var stops: [[Double]]
//    var driver: String
//    var passengers: [String]
//    var uuid: String
//
//    init(title: String, mode: String, type: String, destinationName: String, destination: [Double], stops: [[Double]], driver: String, passengers: [String], uuid: String = UUID().uuidString) {
//        self.title = title
//        self.mode = mode
//        self.type = type
//        self.destinationName = destinationName
//        self.destination = destination
//        self.stops = stops
//        self.driver = driver
//        self.passengers = passengers
//        self.uuid = uuid
//    }
//}

import Foundation
import Firebase

struct CarpoolConstants  {
    static let titleKey = "title"
    static let modeKey = "mode"
    static let typeKey = "type"
    static let destinationNameKey = "destinationName"
    static let destinationKey = "destination"
//    static let stopsKey = "stops"
    static let driverKey = "driver"
    static let passengersKey = "passengers"
    static let uuidKey = "uuid"
}

class Carpool {
    var title: String
    var mode: String
    var type: String
    var destinationName: String
    var destination: [Double]
//    var stops: [[Double]]
    var driver: String
    var passengers: [String]
    var uuid: String
    
    internal init(title: String, mode: String, type: String, destinationName: String, destination: [Double] = [], driver: String, passengers: [String] = [], uuid: String = UUID().uuidString) {
        self.title = title
        self.mode = mode
        self.type = type
        self.destinationName = destinationName
        self.destination = destination
        self.driver = driver
        self.passengers = passengers
        self.uuid = uuid
    }
    
    convenience init?(document: DocumentSnapshot) {
        guard let title = document[CarpoolConstants.titleKey] as? String,
              let mode = document[CarpoolConstants.modeKey] as? String,
              let type = document[CarpoolConstants.typeKey] as? String,
              let destinationName = document[CarpoolConstants.destinationNameKey] as? String,
              let destination = document[CarpoolConstants.destinationKey] as? [Double],
              let driver = document[CarpoolConstants.driverKey] as? String,
              let passengers = document[CarpoolConstants.passengersKey] as? [String],
              let uuid = document[CarpoolConstants.uuidKey] as? String else {return nil}
        
        self.init(title: title, mode: mode, type: type, destinationName: destinationName, destination: destination, driver: driver, passengers: passengers, uuid: uuid)
    }
}


extension Carpool: Equatable {
    static func == (lhs: Carpool, rhs: Carpool) -> Bool {
        return rhs.uuid == lhs.uuid
    }
}//End of extension
