//
//  CarpoolController.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/16/21.
//

import Foundation
import MapKit
//import Firebase
//import FirebaseAuth

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








/*
class CarpoolController {
    // MARK: - Properties
    static let shared = CarpoolController()
    var carpools: [Carpool] = []
    let db = Firestore.firestore()
    var destination: MKMapItem?
    var stops: [CLLocationCoordinate2D] = []
    var passengers: [String] = []
    var driver: String = "Current user name"
    var title: String = "Test"
    var type: String = "work"
    let carpoolCollection = "carpools"
    
    // MARK: - CRUD
    
    func createCarpool() {
        guard let destination = self.destination else {return}
        var destinationCoords: [Double] = []
        destinationCoords.append(destination.placemark.coordinate.latitude)
        destinationCoords.append(destination.placemark.coordinate.longitude)
        
        var stopCoords: [[Double]] = [[]]
        for stop in self.stops {
            var coords: [Double] = []
            coords.append(stop.latitude)
            coords.append(stop.longitude)
            stopCoords.append(coords)
        }
        
        let newCarpool = Carpool(title: title, type: type, destination: destinationCoords, stops: stopCoords, driver: driver, passengers: passengers)
        
        carpools.append(newCarpool)
        stops = []
        let carpoolRef = self.db.collection(self.carpoolCollection)
        carpoolRef.document(newCarpool.uuid).setData([
            CarpoolConstants.titleKey : newCarpool.title,
            CarpoolConstants.typeKey : newCarpool.type,
            CarpoolConstants.destinationKey : newCarpool.destination,
            CarpoolConstants.stopsKey : newCarpool.stops,
            CarpoolConstants.driverKey : newCarpool.driver,
            CarpoolConstants.passengersKey : newCarpool.passengers,
            CarpoolConstants.uuidKey : newCarpool.uuid
        ]) { (error) in
            if let error = error {
                print("\n==== ERROR CREATING CARPOOL IN CLOUDFIRESTORE IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
            } else {
                print("\n===== SUCCESSFULLY! CREATED CARPOOL IN CLOUD FIRESTORE DATABASE=====\n")
            }
        }
    }
    
//
//    func addPasenngers() {
//
//    }
    
 //+++++///
 // MARK: - Looking for
 func fetchDriverId(carpool: Carpool, completion: @escaping(Result<String, NetworkError>) -> Void) {
 db.collection(carpoolCollection).document(carpool.uuid).getDocument { (querySnapshot, error) in
     if let error = error {
         print("\n==== ERROR FETCH BLOCKED USERS FOR FETCH ALL USERS IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
         return completion(.failure(.thrownError(error)))
     } else {
         guard let querySnapshot = querySnapshot,
               let carpoolData = Carpool(document: querySnapshot) else {return completion(.failure(.noData))}
guard let driverID = carpoolData.driver {
             self.db.collection(self.userCollection).document(id).getDocument { (snapshot, error) in
                 if let error = error {
                     print("\n==== ERROR FETCH DRIVER IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                     return completion(.failure(.thrownError(error)))
                 } else {
                     guard let snapshot = snapshot,
                           let driverID = Carpool(document: snapshot) else {return completion(.failure(.unableToDecode))}
                    driver = driverID
                     print("\n===== SUCCESSFULLY! FETCH BLOCKED USERS FOR FETCH ALL USERS =====\n")
                     return completion(.success(blockUserArray))
                 }
             }
         }
     }
 }
}
*/


// appended carpool Id to the group

//DriverId
// passengers Id 
