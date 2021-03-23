//
//  CarpoolController.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/16/21.
//

import Foundation
import MapKit
import Firebase
import SafariServices

class CarpoolController {
    // MARK: - Properties
    static let shared = CarpoolController()
    var carpools: [Carpool] = []
    var work: [Carpool] = []
    var play: [Carpool] = []
    
    var title: String = "Test"
    var mode: String = "work"
    var type: String = "carpool"
    var destination: MKMapItem?
//    var stops: [[Double]] = []
    var driver: String = ""
    var passengers: [String] = []

    let db = Firestore.firestore()
    let carpoolCollection = "carpools"
    let userCollection = "users"
    
    // MARK: - CRUD
    func createCarpool() {
        guard let destination = self.destination else {return}
        guard let driver = UserController.shared.currentUser?.uuid else {return print("currentUser not logged in")}
        let destinationName = destination.name ?? "Destination Unknown"
        var destinationCoords: [Double] = []
        destinationCoords.append(destination.placemark.coordinate.latitude)
        destinationCoords.append(destination.placemark.coordinate.longitude)
        
        let newCarpool = Carpool(title: self.title, mode: self.mode, type: self.type, destinationName: destinationName, destination: destinationCoords, driver: driver, passengers: self.passengers)
        
        carpools.append(newCarpool)
        addCarpoolToCurrentUsersGroup(carpool: newCarpool)
        addCarpoolToPassengersGroup(carpool: newCarpool)
        
        let carpoolRef = self.db.collection(self.carpoolCollection)
        carpoolRef.document(newCarpool.uuid).setData([
            CarpoolConstants.titleKey : newCarpool.title,
            CarpoolConstants.modeKey : newCarpool.mode,
            CarpoolConstants.typeKey : newCarpool.type,
            CarpoolConstants.destinationNameKey : newCarpool.destinationName,
            CarpoolConstants.destinationKey : newCarpool.destination,
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
    
    func addCarpoolToCurrentUsersGroup(carpool: Carpool) {
        guard let currentUser = UserController.shared.currentUser else {return}
        db.collection(userCollection).document(currentUser.uuid).updateData([UserConstants.groupsKey : FieldValue.arrayUnion([carpool.uuid])]) { (error) in
            if let error = error {
                print("\n==== ERROR ADDING TO GROUPs \(#function) : \(error.localizedDescription) : \(error) ====\n")
            }
        }
    }
    
    func addCarpoolToPassengersGroup(carpool: Carpool) {
        if passengers.count != 0 {
            for passenger in passengers {
                db.collection(userCollection).document(passenger).updateData([UserConstants.groupsKey : FieldValue.arrayUnion([carpool.uuid])]) { (error) in
                    if let error = error {
                        print("\n==== ERROR ADDING TO GROUPs \(#function) : \(error.localizedDescription) : \(error) ====\n")
                    }
                }
            }
        }
    }//end func
    
    func fetchGroupsForCurrentUser(completion: @escaping (Result<String, NetworkError>) -> Void) {
        guard let currentUser = UserController.shared.currentUser else {return}
        db.collection(userCollection).document(currentUser.uuid).getDocument { (querySnapshot, error) in
            if let error = error {
                print("\n==== ERROR FETCH FRIENDS IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                return completion(.failure(.thrownError(error)))
            } else {
                guard let querySnapshot = querySnapshot,
                      let userData = User(document: querySnapshot) else {return completion(.failure(.noData))}
                self.carpools = []
                for id in userData.groups {
                    self.db.collection(self.carpoolCollection).document(id).getDocument { (snapshot, error) in
                        if let error = error {
                            print("\n==== ERROR FETCH FRIENDS IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                            return completion(.failure(.thrownError(error)))
                        } else {
                            guard let snapshot = snapshot,
                                  let carpool = Carpool(document: snapshot) else {return completion(.failure(.unableToDecode))}
                            self.carpools.append(carpool)
                            print("\n===== SUCCESSFULLY! FETCH CARPOOOL =====\n")
                            return completion(.success("success"))
                        }
                    }
                }
            }
        }
        self.sortCarpoolsByWorkPlay()
    }//end func
    
    func sortCarpoolsByWorkPlay() {
        self.work = carpools.filter({ (carpool) -> Bool in
            return carpool.mode == "work"
        })
        
        self.play = carpools.filter({ (carpool) -> Bool in
            return carpool.mode == "play"
        })
    }
}//end class
