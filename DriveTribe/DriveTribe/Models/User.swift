//
//  User.swift
//  DriveTribe
//
//  Created by Lee McCormick on 3/18/21.
//
import Foundation
import Firebase

struct UserConstants {
    static let firstNameKey = "firstName"
    static let lastNameKey = "lastName"
    static let userNameKey = "userName"
    static let profilePhotoKey = "profilePhotoKey"
    static let groupsKey = "groups"
    static let carInfoKey = "carInfo"
    static let addressBookKey = "addressBook"
    static let blockedUsersKey = "blockedUsers"
    static let blockedUsersByCurrentUserKey = "blockedUsersByCurrentUser"
    static let friendsKey = "friends"
    static let friendsRequestSentKey = "friendsRequestSent"
    static let friendsRequestReceivedKey = "friendsRequestReceived"
    static let authIDKey = "authID"
    static let uuidKey = "uuid"
    static let lastCurrentLocationKey = "lastCurrentLocation"
}//End of struct

//MARK: - Class
class User: SearchableRecordDelegate {
    
    var firstName: String
    var lastName: String
    var userName: String
    var carInfo: String
    var lastCurrentLocation: [Double]
    var blockedUsers: [String]
    var blockedUsersByCurrentUser: [String]
    var friends: [String]
    var friendsRequestSent: [String]
    var friendsRequestReceived: [String]
    var authID: String
    var uuid: String
    
    internal init(firstName: String, lastName: String, userName: String, carInfo: String = "", lastCurrentLocation: [Double] = [], blockedUsers: [String] = [], blockedUsersByCurrentUser: [String] = [], friends: [String] = [], friendsRequestSent: [String] = [], friendRequestReceived: [String] = [], authID: String = "", uuid: String = UUID().uuidString) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.userName = userName
        self.carInfo = carInfo
        self.lastCurrentLocation = lastCurrentLocation
        self.blockedUsers = blockedUsers
        self.blockedUsersByCurrentUser = blockedUsersByCurrentUser
        self.friends = friends
        self.friendsRequestSent = friendsRequestSent
        self.friendsRequestReceived = friendRequestReceived
        self.authID = authID
        self.uuid = uuid
    }
    
    convenience init?(document: DocumentSnapshot) {
        
        guard let firstName = document[UserConstants.firstNameKey] as? String,
              let lastName = document[UserConstants.lastNameKey] as? String,
              let userName = document[UserConstants.userNameKey] as? String,
              let carInfo = document[UserConstants.carInfoKey] as? String,
              let lastCurrentLocation = document[UserConstants.lastCurrentLocationKey] as? [Double],
              let blockedUsers = document[UserConstants.blockedUsersKey] as? [String],
              let blockedUsersByCurrentUser = document[UserConstants.blockedUsersByCurrentUserKey] as? [String],
              let friends = document[UserConstants.friendsKey] as? [String],
              let friendsRequestSent = document[UserConstants.friendsRequestSentKey] as? [String],
              let friendRequestReceived = document[UserConstants.friendsRequestReceivedKey] as? [String],
              let authID = document[UserConstants.authIDKey] as? String,
              let uuid = document[UserConstants.uuidKey] as? String else {return nil}

        self.init(firstName: firstName, lastName: lastName, userName: userName, carInfo: carInfo, lastCurrentLocation: lastCurrentLocation, blockedUsers: blockedUsers, blockedUsersByCurrentUser: blockedUsersByCurrentUser, friends: friends, friendsRequestSent: friendsRequestSent, friendRequestReceived: friendRequestReceived, authID: authID, uuid: uuid)
    }
}//End of class

//MARK: - Extensions
extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return rhs.uuid == lhs.uuid
    }
}//End of extension


