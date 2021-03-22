//
//  UserController.swift
//  DriveTribe
//
//  Created by Lee McCormick on 3/18/21.
//

import FirebaseFirestore
import Foundation
import Firebase
import FirebaseAuth

class UserController {
    
    //MARK: - Properties
    static var shared = UserController()
    var users: [User] = []
    var currentUser: User?
    let db = Firestore.firestore()
    let userCollection = "users"
    var lastCurrentLocation: [Double] = []

    // MARK: - CRUD Methods
    // MARK: - CREATE
    func signupNewUserAndCreateNewContactWith(firstName: String, lastName: String, userName: String, email: String, password: String, completion: @escaping (Result<User, NetworkError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("\n==== ERROR SING UP NEW USER IN \(#function) : \(error.localizedDescription) : \(error) ====\n")            }
            guard let authResult = result else {return completion(.failure(.noData))}
            let newUser = User(firstName: firstName, lastName: lastName, userName: userName,lastCurrentLocation: self.lastCurrentLocation)
            let userRef = self.db.collection(self.userCollection)
            userRef.document(newUser.uuid).setData([
                                                    UserConstants.firstNameKey : newUser.firstName,
                                                    UserConstants.lastNameKey : newUser.lastName,
                                                    UserConstants.userNameKey : newUser.userName,
                                                    UserConstants.groupsKey : newUser.groups,
                                                    UserConstants.carInfoKey : newUser.carInfo,
                                                    UserConstants.addressBookKey : newUser.addressBook,
                                                    UserConstants.lastCurrentLocationKey : newUser.lastCurrentLocation,
                                                    UserConstants.blockedUsersKey : newUser.blockedUsers,
                                                    UserConstants.blockedUsersByCurrentUserKey : newUser.blockedUsersByCurrentUser,
                                                    UserConstants.friendsKey : newUser.friends,
                                                    UserConstants.friendsRequestSentKey : newUser.friendsRequestSent,
                                                    UserConstants.friendsRequestReceivedKey : newUser.friendsRequestReceived,
                                                    UserConstants.authIDKey : authResult.user.uid,
                                                    UserConstants.uuidKey : newUser.uuid]) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return completion(.failure(.thrownError(error)))
                } else {
                    return completion(.success(newUser))
                }
            }
        }
    }
    
    func loginWith(email: String, password: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("\n==== ERROR LOGGIN USER IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                completion(.failure(.thrownError(error)))
            }
            guard let authDataResult = result else {return completion(.failure(.unableToDecode))}
            guard let email = authDataResult.user.email else {return completion(.failure(.noData))}
            completion(.success(email))
        }
    }
    
    func logout(completion: @escaping (Result<String, NetworkError>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success("==========SUCCESSFULLY! LOGOUT FROM THE SERVER==============="))
        } catch {
            print("\n==== ERROR LOGGING OUT USER IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
            completion(.failure(.thrownError(error)))
        }
    }
    
    // MARK: - READ
    func fetchCurrentUser(completion: @escaping(Result<User, NetworkError>) -> Void) {
        let currentUserID = Auth.auth().currentUser?.uid
        guard let upwrapCurrentUserID = currentUserID else { return completion(.failure(.unableToDecode)) }
        db.collectionGroup(userCollection).whereField(UserConstants.authIDKey, isEqualTo: upwrapCurrentUserID).getDocuments { (users, error) in
            if let error = error {
                print("\n==== ERROR FETCH CURRENT USER IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                return completion(.failure(.thrownError(error)))
            }
            guard let users = users else {return completion(.failure(.noData))}
            for document in users.documents {
                guard let user = User(document: document) else {return completion(.failure(.unableToDecode))}
                self.currentUser = user
                print("====SUCCESSFULLY! FETCH CURRENT USER====!")
                return completion(.success(user))
            }
        }
    }
    
    func fetchAllUsers(completion: @escaping(Result<[User], NetworkError>) -> Void) {
        let currentUserID = Auth.auth().currentUser?.uid
        guard let upwrapCurrentUserID = currentUserID else { return completion(.failure(.unableToDecode)) }
        db.collectionGroup(userCollection).whereField(UserConstants.authIDKey, isNotEqualTo: upwrapCurrentUserID).getDocuments { (users, error) in
            if let error = error {
                print("\n====ERROR  FETCH ALL USER! IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                return completion(.failure(.thrownError(error)))
            }
            guard let users = users else {return completion(.failure(.noData))}
            var userArray: [User] = []
            for document in users.documents {
                guard let user = User(document: document) else {return completion(.failure(.unableToDecode))}
                userArray.append(user)
                print("====SUCCESSFULLY! FETCH ALL USERS! \(#function)====")
            }
            return completion(.success(userArray))
        }
    }
    
    func fetchSpecficUsersBySearchTerm(searchTerm: String, completion: @escaping(Result<[User], NetworkError>) -> Void) {
        let currentUserID = Auth.auth().currentUser?.uid
        guard let upwrapCurrentUserID = currentUserID else { return completion(.failure(.unableToDecode)) }
        db.collectionGroup(userCollection).whereField(UserConstants.authIDKey, isNotEqualTo: upwrapCurrentUserID).getDocuments { (users, error) in
            if let error = error {
                print("\n====ERROR  FETCH ALL USER! IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                return completion(.failure(.thrownError(error)))
            }
            guard let users = users else {return completion(.failure(.noData))}
            var userArray: [User] = []
            for document in users.documents {
                guard let user = User(document: document) else {return completion(.failure(.unableToDecode))}
                userArray.append(user)
                print("====SUCCESSFULLY! FETCH ALL USERS! \(#function)====")
            }
            return completion(.success(userArray))
        }
    }
    
    func fetchPendingFriendRequestsSentBy(currentUser: User, completion: @escaping (Result<[User], NetworkError>) -> Void) {
        db.collection(userCollection).document(currentUser.uuid).getDocument { (querySnapshot, error) in
            if let error = error {
                print("\n==== ERROR FETCH PENDING FRIEND REQUESTS SENT IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                return completion(.failure(.thrownError(error)))
            } else {
                guard let querySnapshot = querySnapshot,
                      let userData = User(document: querySnapshot) else {return completion(.failure(.noData))}
                var pendingFriendRequestArray: [User] = []
                for id in userData.friendsRequestSent {
                    self.db.collection(self.userCollection).document(id).getDocument { (snapshot, error) in
                        if let error = error {
                            print("\n==== ERROR FETCH PENDING FRIEND REQUESTS SENT IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                            return completion(.failure(.thrownError(error)))
                        } else {
                            guard let snapshot = snapshot,
                                  let potentialFriend = User(document: snapshot) else {return completion(.failure(.unableToDecode))}
                            pendingFriendRequestArray.append(potentialFriend)
                            print("\n===== SUCCESSFULLY! FETCH PENDING FRIEND REQUEST SENT =====\n")
                            return completion(.success(pendingFriendRequestArray))
                        }
                    }
                }
            }
        }
    }
    
    func fetchFriendRequestsReceived(currentUser: User, completion: @escaping (Result<[User], NetworkError>) -> Void) {
        db.collection(userCollection).document(currentUser.uuid).getDocument { (querySnapshot, error) in
            if let error = error {
                print("\n==== ERROR FETCH FRIEND REQUEST RECEIVED IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                return completion(.failure(.thrownError(error)))
            } else {
                guard let querySnapshot = querySnapshot,
                      let userData = User(document: querySnapshot) else {return completion(.failure(.noData))}
                var friendRequestReceievedArray: [User] = []
                for id in userData.friendsRequestReceived {
                    self.db.collection(self.userCollection).document(id).getDocument { (snapshot, error) in
                        if let error = error {
                            print("\n==== ERROR FETCH FRIEND REQUESTS RECEIVED IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                            return completion(.failure(.thrownError(error)))
                        } else {
                            guard let snapshot = snapshot,
                                  let fetchFriendRequestReceived = User(document: snapshot) else {return completion(.failure(.unableToDecode))}
                            friendRequestReceievedArray.append(fetchFriendRequestReceived)
                            print("\n===== SUCCESSFULLY! FETCH FRIEND REQUESTS RECEIVED  =====\n")
                            return completion(.success(friendRequestReceievedArray))
                        }
                    }
                }
            }
        }
    }
    
    func fetchFriendsFor(currentUser: User, completion: @escaping (Result<[User], NetworkError>) -> Void) {
        db.collection(userCollection).document(currentUser.uuid).getDocument { (querySnapshot, error) in
            if let error = error {
                print("\n==== ERROR FETCH FRIENDS IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                return completion(.failure(.thrownError(error)))
            } else {
                guard let querySnapshot = querySnapshot,
                      let userData = User(document: querySnapshot) else {return completion(.failure(.noData))}
                var friendsArray: [User] = []
                for id in userData.friends {
                    self.db.collection(self.userCollection).document(id).getDocument { (snapshot, error) in
                        if let error = error {
                            print("\n==== ERROR FETCH FRIENDS IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                            return completion(.failure(.thrownError(error)))
                        } else {
                            guard let snapshot = snapshot,
                                  let fetchFriend = User(document: snapshot) else {return completion(.failure(.unableToDecode))}
                            friendsArray.append(fetchFriend)
                            print("\n===== SUCCESSFULLY! FETCH FRIEND =====\n")
                            return completion(.success(friendsArray))
                        }
                    }
                }
            }
        }
    }
    
    func fetchBlockedUsersByCurrentUser(_ currentUser: User, completion: @escaping (Result<[User], NetworkError>) -> Void) {
        db.collection(userCollection).document(currentUser.uuid).getDocument { (querySnapshot, error) in
            if let error = error {
                print("\n==== ERROR FETCH BLOCKED USER FOR CURRENT USER IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                return completion(.failure(.thrownError(error)))
            } else {
                guard let querySnapshot = querySnapshot,
                      let userData = User(document: querySnapshot) else {return completion(.failure(.noData))}
                var blockUserArray: [User] = []
                for id in userData.blockedUsersByCurrentUser {
                    self.db.collection(self.userCollection).document(id).getDocument { (snapshot, error) in
                        if let error = error {
                            print("\n==== ERROR FETCH BLOCKED USER FOR CURRENT USER IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                            return completion(.failure(.thrownError(error)))
                        } else {
                            guard let snapshot = snapshot,
                                  let blocksUsers = User(document: snapshot) else {return completion(.failure(.unableToDecode))}
                            blockUserArray.append(blocksUsers)
                            print("\n===== SUCCESSFULLY! FETCH BLOCKED USER FOR CURRENT USER  =====\n")
                            return completion(.success(blockUserArray))
                        }
                    }
                }
            }
        }
    }
    
    func fetchBlockedUsersToFetchAllUsers(_ currentUser: User, completion: @escaping (Result<[User], NetworkError>) -> Void) {
        db.collection(userCollection).document(currentUser.uuid).getDocument { (querySnapshot, error) in
            if let error = error {
                print("\n==== ERROR FETCH BLOCKED USERS FOR FETCH ALL USERS IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                return completion(.failure(.thrownError(error)))
            } else {
                guard let querySnapshot = querySnapshot,
                      let userData = User(document: querySnapshot) else {return completion(.failure(.noData))}
                var blockUserArray: [User] = []
                for id in userData.blockedUsers {
                    self.db.collection(self.userCollection).document(id).getDocument { (snapshot, error) in
                        if let error = error {
                            print("\n==== ERROR FETCH BLOCKED USERS FOR FETCH ALL USERS IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                            return completion(.failure(.thrownError(error)))
                        } else {
                            guard let snapshot = snapshot,
                                  let blocksUsers = User(document: snapshot) else {return completion(.failure(.unableToDecode))}
                            blockUserArray.append(blocksUsers)
                            print("\n===== SUCCESSFULLY! FETCH BLOCKED USERS FOR FETCH ALL USERS =====\n")
                            return completion(.success(blockUserArray))
                        }
                    }
                }
            }
        }
    }

    // MARK: - UPDATE
    func sendFriendRequest(to user: User, completion: @escaping (Result<User, NetworkError>) -> Void) {
            
            guard let upwrapCurrentUser = self.currentUser else {return}
            if !upwrapCurrentUser.friends.contains(user.uuid) && !upwrapCurrentUser.friendsRequestSent.contains(user.uuid) &&  !upwrapCurrentUser.blockedUsers.contains(user.uuid) {
                
                db.collection(userCollection).document(user.uuid).updateData([UserConstants.friendsRequestReceivedKey : FieldValue.arrayUnion([upwrapCurrentUser.uuid])]) { (error) in
                    if let error = error {
                        print("\n==== ERROR IN SEND FRIEND REQUEST \(#function) : \(error.localizedDescription) : \(error) ====\n")
                        return completion(.failure(.thrownError(error)))
                    } else {
                        print("\n===== SUCCESSFULLY! ADD FRIEND REQUEST RECEIVED FOR \(user.userName)=====\n")
                        return completion(.success(user))
                    }
                }
                
                db.collection(userCollection).document(upwrapCurrentUser.uuid).updateData([UserConstants.friendsRequestSentKey : FieldValue.arrayUnion([user.uuid])]) { (error) in
                    if let error = error {
                        print("\n==== ERROR IN SEND FRIEND REQUEST \(#function) : \(error.localizedDescription) : \(error) ====\n")
                        return completion(.failure(.thrownError(error)))
                    } else {
                        print("\n===== SUCCESSFULLY! ADD FRIEND REQUEST SENT KEY FOR \(upwrapCurrentUser.userName)=====\n")
                        return completion(.success(user))
                    }
                }
            } else {
                print("\n==== ERROR IN SEND FRIEND REQUEST \(#function) BECAUSE IT IS A REPEAT REQUEST!  ====\n")
                return completion(.failure(.repeatRequest))
            }
        }
    
    func acceptFriendRequest(user: User, completion: @escaping (Result<User, NetworkError>) -> Void) {
            guard let currentUser = currentUser else {return}
            
            db.collection(userCollection).document(currentUser.uuid).updateData([UserConstants.friendsKey : FieldValue.arrayUnion([user.uuid])]) { (error) in
                if let error = error {
                    print("\n==== ERROR ACCEPT FRIEND REQUEST IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                    return completion(.failure(.thrownError(error)))
                } else {
                    print("FINALLY! \(currentUser.firstName)  ACCEPT \(user.firstName) FRIEND'S REQUEST.")
                }
            }
            
            db.collection(userCollection).document(currentUser.uuid).updateData([UserConstants.friendsRequestReceivedKey : FieldValue.arrayRemove([user.uuid])]) { (error) in
                if let error = error {
                    print("\n==== ERROR ACCEPT FRIEND REQUEST IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                    return completion(.failure(.thrownError(error)))
                } else {
                    print("SO! \(user.firstName) IS REMOVE FROM \(currentUser.firstName) FRIEND'S REQUEST RECEIVED' LIST.")
                }
            }
            
            db.collection(userCollection).document(user.uuid).updateData([UserConstants.friendsKey : FieldValue.arrayUnion([currentUser.uuid])]) { (error) in
                if let error = error {
                    print("\n==== ERROR ACCEPT FRIEND REQUEST IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                    return completion(.failure(.thrownError(error)))
                } else {
                    print("FINALLY! \(user.firstName) GOT ACCEPTED FROM \(currentUser.firstName) TO BE FRIEND.")
                }
            }
            
            db.collection(userCollection).document(user.uuid).updateData([UserConstants.friendsRequestSentKey : FieldValue.arrayRemove([currentUser.uuid])]) { (error) in
                if let error = error {
                    print("\n==== ERROR ACCEPT FRIEND REQUEST IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                    return completion(.failure(.thrownError(error)))
                } else {
                    print("SO!\(currentUser.firstName) IS REMOVE FROM \(user.firstName)  FRIEND'S REQUEST LIST.")
                }
            }
             print("\n===== SUCCESSFULLY! ACCEPTED FRIEND REQUEST =====\n")
            completion(.success(user))
        }

    // MARK: - DELETE
    func cancelFriendRequest(to user: User, completion: @escaping (Result<User, NetworkError>) -> Void) {
        guard let upwrapCurrentUser = self.currentUser else {return}
        
        db.collection(userCollection).document(user.uuid).updateData([UserConstants.friendsRequestReceivedKey : FieldValue.arrayRemove([upwrapCurrentUser.uuid])]) { (error) in
            if let error = error {
                print("\n==== ERROR CANCEL FRIEND REQUEST IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                return completion(.failure(.thrownError(error)))
            } else {
                print("\n===== SUCCESSFULLY! CANCEL FRIEND REQUEST BY DELETING FRIEND REQUEST RECEIVED =====\n")
                return completion(.success(user))
            }
        }
        
        db.collection(userCollection).document(upwrapCurrentUser.uuid).updateData([UserConstants.friendsRequestSentKey : FieldValue.arrayRemove([user.uuid])]) { (error) in
            if let error = error {
                print("\n==== ERROR CANCEL FRIEND REQUEST IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                return completion(.failure(.thrownError(error)))
            } else {
                print("\n===== SUCCESSFULLY! CANCEL FRIEND REQUEST BY DELETING FRIEND REQUEST SENT =====\n")
                return completion(.success(user))
            }
        }
    }
    
    func blockUser(_ user: User, completion: @escaping (Result<User, NetworkError>) -> Void) {
        guard let currentUser = currentUser else {return}
        db.collection(userCollection).document(currentUser.uuid).updateData([UserConstants.friendsKey : FieldValue.arrayRemove([user.uuid])]) { (error) in
            if let error = error {
                print("\n==== ERROR BLOCK USER IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                return completion(.failure(.thrownError(error)))
            } else {
                print("FINALLY! \(currentUser.firstName) UNFRIENDED AND GOING TO BLOCK \(user.firstName) ")
            }
        }
        
        db.collection(userCollection).document(currentUser.uuid).updateData([UserConstants.blockedUsersKey : FieldValue.arrayUnion([user.uuid])]) { (error) in
            if let error = error {
                print("\n==== ERROR BLOCK USER IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                return completion(.failure(.thrownError(error)))
            } else {
                print("FINALLY! \(currentUser.firstName) BLOCKED \(user.firstName).")
            }
        }
        
        db.collection(userCollection).document(currentUser.uuid).updateData([UserConstants.blockedUsersByCurrentUserKey : FieldValue.arrayUnion([user.uuid])]) { (error) in
            if let error = error {
                print("\n==== ERROR BLOCK USER IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                return completion(.failure(.thrownError(error)))
            } else {
                print("FINALLY! \(currentUser.firstName) BLOCKED \(user.firstName).")
            }
        }
        
        db.collection(userCollection).document(user.uuid).updateData([UserConstants.friendsKey : FieldValue.arrayRemove([currentUser.uuid])]) { (error) in
            if let error = error {
                print("\n==== ERROR BLOCK USER IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                return completion(.failure(.thrownError(error)))
            } else {
                print("FINALLY! \(user.firstName) ALSO GET BLOCKED AND UNFRIENDED \(currentUser.firstName).")
            }
        }
        
        db.collection(userCollection).document(user.uuid).updateData([UserConstants.blockedUsersKey : FieldValue.arrayUnion([currentUser.uuid])]) { (error) in
            if let error = error {
                print("\n==== ERROR BLOCK USER IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                return completion(.failure(.thrownError(error)))
            } else {
                print("FINALLY! \(user.firstName) GOT \(currentUser.firstName) IN BLOCKED LIST.")
            }
        }
    }
    
    func unfriendUser(_ user: User, completion: @escaping (Result<User, NetworkError>) -> Void) {
        guard let currentUser = currentUser else {return}
        db.collection(userCollection).document(currentUser.uuid).updateData([UserConstants.friendsKey : FieldValue.arrayRemove([user.uuid])]) { (error) in
            if let error = error {
                print("\n==== ERROR UNFRIEND USER IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                return completion(.failure(.thrownError(error)))
            } else {
                print("FINALLY! \(currentUser.firstName)  UNFRIEND \(user.firstName).")
            }
        }
        
        db.collection(userCollection).document(user.uuid).updateData([UserConstants.friendsKey : FieldValue.arrayRemove([currentUser.uuid])]) { (error) in
            if let error = error {
                print("\n==== ERROR UNFRIEND USER IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                return completion(.failure(.thrownError(error)))
            } else {
                print("FINALLY! \(user.firstName) GOT \(currentUser.firstName) OUT FRIEND LIST.")
            }
        }
    }
    
    func unblockedUser(_ user: User, completion: @escaping (Result<User, NetworkError>) -> Void) {
        
        guard let currentUser = currentUser else {return}
        
        db.collection(userCollection).document(currentUser.uuid).updateData([UserConstants.blockedUsersByCurrentUserKey : FieldValue.arrayRemove([user.uuid])]) { (error) in
            if let error = error {
                print("\n==== ERROR UNBLOCKED USER IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                return completion(.failure(.thrownError(error)))
            } else {
                print("FINALLY! \(currentUser.firstName)  UNBLOCKED \(user.firstName).")
            }
        }
        
        db.collection(userCollection).document(currentUser.uuid).updateData([UserConstants.blockedUsersKey : FieldValue.arrayRemove([user.uuid])]) { (error) in
            if let error = error {
                print("\n==== ERROR UNBLOCKED USER IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                return completion(.failure(.thrownError(error)))
            } else {
                print("FINALLY! \(currentUser.firstName)  UNBLOCKED \(user.firstName).")
            }
        }
        
        db.collection(userCollection).document(user.uuid).updateData([UserConstants.blockedUsersKey : FieldValue.arrayRemove([currentUser.uuid])]) { (error) in
            if let error = error {
                print("\n==== ERROR UNBLOCKED USER IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                return completion(.failure(.thrownError(error)))
            } else {
                print("FINALLY! \(user.firstName) GOT OUT FROM \(currentUser.firstName)  BLOCKED LIST.")
            }
        }
    }
    
    
    //Delete Account
    func deleteUser(currentUser: User, completion: @escaping (Result<User, NetworkError>) -> Void) {
        
        let docRef = db.collection(userCollection).document(currentUser.uuid)
        
        docRef.delete { (error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            } else {
                self.logout { (results) in
                                    switch results {
                                    
                                    case .success(let response):
                                        print(response)
                                    case .failure(let error):
                                        print("\n==== ERROR IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                                    }
                                }
                                
                return completion(.success(currentUser))
            }
        }
    
        //Save Delete User Some where
        
    }
    
    
}


/* // NOTE :
 Create, read, update, delete:
 Get current location (Stan):
 Delete Account: ?? ===> What does it mean delete account??
 _________________________________________________________________
 NEED TO FETCH THE ALL THE USERS THAT ARE NOT CURRENT USER, NOT IN THE `blockedUsers`, NOT IN THE `friends`, NOT IN THE `friendsRequestSent`

 func fetchAllUsersWithOutBlockedAndCurrentUser(currentUser: User, completion: @escaping(Result<[User], NetworkError>) -> Void) {
 db.collectionGroup(userCollection).whereField(UserConstants.authIDKey, isNotEqualTo: currentUser.authID).getDocuments { (users, error) in
 if let error = error {
 print("Error in FETCH ALL USER!\(#function) : \(error.localizedDescription) \n---\n \(error)")
 return completion(.failure(.thrownError(error)))
 }
 
 guard let users = users else {return completion(.failure(.noData))}
 var userArray: [User] = []
 for document in users.documents {
 guard let user = User(document: document) else {return completion(.failure(.unableToDecode))}
 
 
 var blockedUsers: [User] = []
 self.fetchBlockedUsersByCurrentUser(currentUser) { (results) in
 switch results {
 case .success(let users):
 blockedUsers = users
 case .failure(let error):
 completion(.failure(.thrownError(error)))
 }
 }
 for blockedUser in blockedUsers {
 if user.uuid != blockedUser.uuid {
 print("--------------------user.uuid  : \(user.uuid) in blockedUser.uuid  \(blockedUser.uuid ) \(#function) : ----------------------------\n)")
 userArray.append(user)
 }
 }
 }
 return completion(.success(userArray))
 }
 }
 
 */

