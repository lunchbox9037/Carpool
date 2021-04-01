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
    var driver: String = ""
    var passengers: [String] = []

    let db = Firestore.firestore()
    let carpoolCollection = "carpools"
    let userCollection = "users"
    let messageCollection = "messages"
    let groupsCollection = "groups"
    let rideTribeIconKey = "RideTribeIconLarge"
    
    // MARK: - CRUD
    func createCarpool() {
        guard let destination = self.destination else {return}
        guard let driver = UserController.shared.currentUser?.uuid else {return print("currentUser not logged in")}
        let destinationName = destination.name ?? "Destination Unknown"
        let uniquePassengers = Array(Set(passengers))
        var destinationCoords: [Double] = []
        destinationCoords.append(destination.placemark.coordinate.latitude)
        destinationCoords.append(destination.placemark.coordinate.longitude)
        
        let newCarpool = Carpool(title: self.title, mode: self.mode, type: self.type, destinationName: destinationName, destination: destinationCoords, driver: driver, passengers: uniquePassengers)
        

        self.destination = nil
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
        
        var driverMessage = "Meet Up"
        if newCarpool.type == "carpool" {
            driverMessage = "Driver: \(UserController.shared.currentUser?.firstName ?? "Unknown")"
        }
        
        let sender = Sender(photoURL: "", senderId: rideTribeIconKey, displayName: "Chat Bot")
        let message = Message(sender: sender, messageId: UUID().uuidString, sentDate: Date(), kind: .text("Start chatting with your RideTribe!\nTap the map for directions.\n\(driverMessage)"))
        
        let messageDate = Date()
        let dateString = ChatViewController.dateFormatter.string(from: messageDate)
        
        var content = ""
        switch message.kind {
        case .text(let messageText):
            content = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        let newMessageEntry: [String:Any] = [
            "id" : message.messageId,
            "type" : message.kind.messageKindString,
            "content" : content,
            "date" : dateString,
            "senderID" : sender.senderId,
            "senderUserName" : sender.displayName
        ]

        self.db.collection(self.carpoolCollection).document(newCarpool.uuid).collection(messageCollection).addDocument(data: newMessageEntry) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }//end func
    
    func addCarpoolToCurrentUsersGroup(carpool: Carpool) {
        guard let currentUser = UserController.shared.currentUser else {return}
        
        db.collection(userCollection).document(currentUser.uuid).collection(groupsCollection).document(carpool.uuid).setData(["nothing":"nil"]) { (error) in
            if let error =  error {
                print(error.localizedDescription)
            }
        }
//        db.collection(userCollection).document(currentUser.uuid).updateData([UserConstants.groupsKey : FieldValue.arrayUnion([carpool.uuid])]) { (error) in
//            if let error = error {
//                print("\n==== ERROR ADDING TO GROUPs \(#function) : \(error.localizedDescription) : \(error) ====\n")
//            }
//        }
    }//end func
    
    func addCarpoolToPassengersGroup(carpool: Carpool) {
        if passengers.count != 0 {
            for passenger in passengers {
                db.collection(userCollection).document(passenger).collection(groupsCollection).document(carpool.uuid).setData(["nothing":"nil"]) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }

//                db.collection(userCollection).document(passenger).updateData([UserConstants.groupsKey : FieldValue.arrayUnion([carpool.uuid])]) { (error) in
//                    if let error = error {
//                        print("\n==== ERROR ADDING TO GROUPs \(#function) : \(error.localizedDescription) : \(error) ====\n")
//                    }
//                }
            }
        }
    }//end func
    
    func fetchGroupsForCurrentUser(completion: @escaping (Result<String, NetworkError>) -> Void) {
        guard let currentUser = UserController.shared.currentUser else {return print("no user logged in")}
        db.collection(userCollection).document(currentUser.uuid).collection(groupsCollection).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let documents = querySnapshot?.documents else {return completion(.failure(.noData))}
            self.carpools = []

            print(documents.count)
            for document in documents {
                
                print(document.documentID)
                let carpoolID = document.documentID
                self.db.collection(self.carpoolCollection).document(carpoolID).getDocument { (snapshot, error) in
                    if let error = error {
                        print("\n==== ERROR FETCH groups IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
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
//        db.collection(userCollection).document(currentUser.uuid).getDocument { (querySnapshot, error) in
//            if let error = error {
//                print("\n==== ERROR FETCH Groups IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
//                return completion(.failure(.thrownError(error)))
//            } else {
//                guard let querySnapshot = querySnapshot,
//                      let userData = User(document: querySnapshot) else {return completion(.failure(.noData))}
//                self.carpools = []
//                for id in userData.groups {
//                    self.db.collection(self.carpoolCollection).document(id).getDocument { (snapshot, error) in
//                        if let error = error {
//                            print("\n==== ERROR FETCH groups IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
//                            return completion(.failure(.thrownError(error)))
//                        } else {
//                            guard let snapshot = snapshot,
//                                  let carpool = Carpool(document: snapshot) else {return completion(.failure(.unableToDecode))}
//                            self.carpools.append(carpool)
//                            print("\n===== SUCCESSFULLY! FETCH CARPOOOL =====\n")
//                            return completion(.success("success"))
//                        }
//                    }
//                }
//            }
        }
    }//end func
    
    func fetchPassengersIn(carpool: Carpool, completion: @escaping (Result<[User], NetworkError>) -> Void) {
        db.collection(carpoolCollection).document(carpool.uuid).getDocument { (querySnapshot, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let querySnapshot = querySnapshot,
                  let carpoolData = Carpool(document: querySnapshot) else {return completion(.failure(.noData))}
            
            var passengers: [User] = []
            for passenger in carpoolData.passengers {
                self.db.collection(self.userCollection).document(passenger).getDocument { (snapshot, error) in
                    if let error = error {
                        return completion(.failure(.thrownError(error)))
                    }
                    
                    guard let snapshot = snapshot,
                          let passenger = User(document: snapshot) else {return completion(.failure(.noData))}
                    passengers.append(passenger)
                    return completion(.success(passengers))
                }
            }
        }
    }//end func
    
    func fetchDriverIn(carpool: Carpool, completion: @escaping (Result<User, NetworkError>) -> Void) {
        db.collection(carpoolCollection).document(carpool.uuid).getDocument { (querySnapshot, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let querySnapshot = querySnapshot,
                  let carpoolData = Carpool(document: querySnapshot) else {return completion(.failure(.noData))}
            
            self.db.collection(self.userCollection).document(carpoolData.driver).getDocument { (snapshot, error) in
                if let error = error {
                    return completion(.failure(.thrownError(error)))
                }
                
                guard let snapshot = snapshot,
                      let driver = User(document: snapshot) else {return completion(.failure(.noData))}
                return completion(.success(driver))
            }
        }
    }//end func
    
    func sortCarpoolsByWorkPlay() {
//        self.work = []
//        self.play = []
        self.work = carpools.filter({ (carpool) -> Bool in
            return carpool.mode == "work"
        })
        
        self.play = carpools.filter({ (carpool) -> Bool in
            return carpool.mode == "play"
        })
    }//end func
    
    
    func sendMessage(message: Message, carpoolID: String) {
        guard let currentUser = UserController.shared.currentUser else {return}
        
        let messageDate = message.sentDate
        let dateString = ChatViewController.dateFormatter.string(from: messageDate)
        
        var content = ""
        switch message.kind {
        case .text(let messageText):
            content = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        let newMessageEntry: [String:Any] = [
            "id" : message.messageId,
            "type" : message.kind.messageKindString,
            "content" : content,
            "date" : dateString,
            "senderID" : currentUser.uuid,
            "senderUserName" : currentUser.userName
        ]

        self.db.collection(self.carpoolCollection).document(carpoolID).collection(messageCollection).addDocument(data: newMessageEntry) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }//end func
    
    func getAllMessagesForConversation(with carpoolID: String, completion: @escaping (Result<[Message], NetworkError>) -> Void) {
        db.collection(carpoolCollection).document(carpoolID).collection(messageCollection).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let snapshot = querySnapshot else {return completion(.failure(.noData))}
            print(snapshot.documents)

            let messages: [Message] = snapshot.documents.compactMap({ dictionary in
                guard let userName = dictionary["senderUserName"] as? String,
                      let messageID = dictionary["id"] as? String,
                      let content = dictionary["content"] as? String,
                      let senderID = dictionary["senderID"] as? String,
                      let _ = dictionary["type"] as? String,
                      let dateString = dictionary["date"] as? String,
                      let date = ChatViewController.dateFormatter.date(from: dateString) else {return nil}

                let sender = Sender(photoURL: "", senderId: senderID, displayName: userName)

                return Message(sender: sender, messageId: messageID, sentDate: date, kind: .text(content))
            })

            completion(.success(messages))
        }
    }//end func
    
    func delete(carpool: Carpool, completion: @escaping (Result<String, NetworkError>) -> Void) {
        guard let currentUser = UserController.shared.currentUser else {return}
        
        if carpool.driver == currentUser.uuid {
            print("driver delete")
            self.db.collection(self.userCollection).document(currentUser.uuid).collection(self.groupsCollection).document(carpool.uuid).delete()
            
            for passenger in carpool.passengers {
                print("deleted passenger")
                print(passenger)
                self.db.collection(self.userCollection).document(passenger).collection(self.groupsCollection).document(carpool.uuid).delete { (error) in
                    if let error = error {
                        return completion(.failure(.thrownError(error)))
                    }
                }
            }
            
            db.collection(carpoolCollection).document(carpool.uuid).delete { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(.thrownError(error)))
                } else {
                    guard let indexToDelete = self.carpools.firstIndex(of: carpool) else {return}
                    self.carpools.remove(at: indexToDelete)
                    self.sortCarpoolsByWorkPlay()
                    
                    
                    return completion(.success("success"))
                }
            }
            
        } else {
            self.db.collection(self.userCollection).document(currentUser.uuid).collection(self.groupsCollection).document(carpool.uuid).delete { (error) in
                if let error = error {
                    return completion(.failure(.thrownError(error)))
                }
            }
        }
    }//end func
}//end class
