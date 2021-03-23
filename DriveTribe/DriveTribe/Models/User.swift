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
    var profilePhoto: UIImage? {
        get {
            guard let data = profilePhotoData else {return nil}
            return UIImage(data: data)
        } set {
            profilePhotoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    var profilePhotoData: Data?
    var groups: [String]
    var carInfo: String
    //var lastCurrentLocation: String
    //var addressBook: String
    var addressBook: [Double]
    var lastCurrentLocation: [Double]
    var blockedUsers: [String]
    var blockedUsersByCurrentUser: [String]
    var friends: [String]
    var friendsRequestSent: [String]
    var friendsRequestReceived: [String]
    var authID: String
    var uuid: String
   
    
    internal init(firstName: String, lastName: String, userName: String, profilePhoto: UIImage? = nil, groups: [String] = [], carInfo: String = "", addressBook: [Double] = [], lastCurrentLocation: [Double] = [], blockedUsers: [String] = [], blockedUsersByCurrentUser: [String] = [], friends: [String] = [], friendsRequestSent: [String] = [], friendRequestReceived: [String] = [], authID: String = "", uuid: String = UUID().uuidString) {
        self.firstName = firstName
        self.lastName = lastName
        self.userName = userName
        self.groups = groups
        self.carInfo = carInfo
        self.addressBook = addressBook
        self.lastCurrentLocation = lastCurrentLocation
        self.blockedUsers = blockedUsers
        self.blockedUsersByCurrentUser = blockedUsersByCurrentUser
        self.friends = friends
        self.friendsRequestSent = friendsRequestSent
        self.friendsRequestReceived = friendRequestReceived
        self.authID = authID
        self.uuid = uuid
        self.profilePhoto = profilePhoto
    }
    
    convenience init?(document: DocumentSnapshot) {
        
        guard let firstName = document[UserConstants.firstNameKey] as? String,
              let lastName = document[UserConstants.lastNameKey] as? String,
              let userName = document[UserConstants.userNameKey] as? String,
              let groups = document[UserConstants.groupsKey] as? [String],
              let carInfo = document[UserConstants.carInfoKey] as? String,
              let addressBook = document[UserConstants.addressBookKey] as? [Double],
              let lastCurrentLocation = document[UserConstants.lastCurrentLocationKey] as? [Double],
              let blockedUsers = document[UserConstants.blockedUsersKey] as? [String],
              let blockedUsersByCurrentUser = document[UserConstants.blockedUsersByCurrentUserKey] as? [String],
              let friends = document[UserConstants.friendsKey] as? [String],
              let friendsRequestSent = document[UserConstants.friendsRequestSentKey] as? [String],
              let friendRequestReceived = document[UserConstants.friendsRequestReceivedKey] as? [String],
              let authID = document[UserConstants.authIDKey] as? String,
              let uuid = document[UserConstants.uuidKey] as? String else {return nil}
        
        var profilePhoto: UIImage?
        
        if let profilePhotoData = document["profilePhoto"] as? Data {
            profilePhoto = UIImage(data: profilePhotoData)
        }
        
        self.init(firstName: firstName, lastName: lastName, userName: userName, profilePhoto: profilePhoto, groups: groups, carInfo: carInfo, addressBook: addressBook, lastCurrentLocation: lastCurrentLocation, blockedUsers: blockedUsers, blockedUsersByCurrentUser: blockedUsersByCurrentUser, friends: friends, friendsRequestSent: friendsRequestSent, friendRequestReceived: friendRequestReceived, authID: authID, uuid: uuid)
    }
}//End of class

//MARK: - Extensions
extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return rhs.uuid == lhs.uuid
    }
}//End of extension

/* NOTE
 //    static addressBookKey = "addressBook" Array or what ??
 var lastCurrentLocation: String

 //______________________________________________________________________________________
 */

