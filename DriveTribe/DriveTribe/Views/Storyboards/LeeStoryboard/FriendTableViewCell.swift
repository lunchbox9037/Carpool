//
//  FriendTableViewCell.swift
//  DriveTribe
//
//  Created by Lee McCormick on 3/18/21.
//

import UIKit

// MARK: - Protocol
protocol FriendTableViewCellCellDelagate: AnyObject {
    func unfriendButtonTapped(sender: FriendTableViewCell)
}

class FriendTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var unfriendButton: UIButton!
    
    var friend: User? {
        didSet {
            updateView(friend: friend!)
        }
    }
    
    weak var delegate: FriendTableViewCellCellDelagate?
    
    // MARK: - Actions
    @IBAction func unfriendButtonTapped(_ sender: Any) {
        delegate?.unfriendButtonTapped(sender: self)
    }
    
    // MARK: - Helper Fuctions
    func updateView(friend: User) {
        userNameLabel.text = friend.userName
        unfriendButton.setTitle("UNFRIEND", for: .normal)
    }
}

/*
// MARK: - Helper Fuctions
extension FriendTableViewCell {
    
    func fetchCurrentUser() {
        UserController.shared.fetchCurrentUser { (results) in
            DispatchQueue.main.async {
                switch results {
                           case .success(let currentUser):
                               self.currentUser = currentUser
                               guard let friend = self.friend else {return}
                               
                               if currentUser.friends.contains(friend.uuid) {
                                   print("--------------------UNFRIEND : \(currentUser.friends.contains(friend.uuid)) in \(#function) : ----------------------------\n)")
                                   self.delegate?.unfriendButtonTapped(sender: self)
                                   self.updateActionButtonTittle(action: "UNFRIEND")
                               }
                               
                               
                           case .failure(let error):
                               print("\n==== ERROR IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                           }  
            }
           
        }
    }
    
    func fetchAllUsers() {
        UserController.shared.fetchAllUsers { (results) in
            switch results {
            case .success(let users):
                self.allUsers = users
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        
        
        func setupViewForFriends() {
            UserController.shared.fetchCurrentUser { (results) in
                DispatchQueue.main.async {
                    switch results {
                    case .success(let currenUser):
                        self.currentUser = currenUser
                        UserController.shared.fetchFriendsFor(currentUser: currenUser) { (results) in
                            switch results {
                            case .success(let fetchFriends):
                                self.friends = fetchFriends
                            case .failure(let error):
                                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                            }
                        }
                    case .failure(let error):
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    }
                }
            }
        }
        
        func setupViewForFriendRequestsSent() {
            UserController.shared.fetchCurrentUser { (results) in
                DispatchQueue.main.async {
                    switch results {
                    case .success(let currenUser):
                        self.currentUser = currenUser
                        UserController.shared.fetchPendingFriendRequestsSentBy(currentUser: currenUser) { (results) in
                            switch results {
                            case .success(let pendingFriendRequests):
                                self.friendRequestsSent = pendingFriendRequests
                            case .failure(let error):
                                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                            }
                        }
                    case .failure(let error):
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    }
                }
            }
        }
        
        func setupViewForFriendRequestsReceived() {
            UserController.shared.fetchCurrentUser { (results) in
                DispatchQueue.main.async {
                    switch results {
                    case .success(let currenUser):
                        self.currentUser = currenUser
                        UserController.shared.fetchFriendRequestsReceived(currentUser: currenUser) { (results) in
                            switch results {
                            case .success(let friendsReceived):
                                self.friendRequestsReceived = friendsReceived
                            case .failure(let error):
                                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                            }
                        }
                    case .failure(let error):
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    }
                }
            }
        }
    }
}
*/
