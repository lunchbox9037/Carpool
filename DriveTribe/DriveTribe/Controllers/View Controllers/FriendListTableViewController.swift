//
//  FriendListTableViewController.swift
//  DriveTribe
//
//  Created by Lee McCormick on 3/18/21.
//

import UIKit

class FriendListTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var friendSearchBar: UISearchBar!
    
    // MARK: - Properties
    var isSearching: Bool = false
    var users: [User] = []
    var friends: [User] = []
    var friendRequestsSent: [User] = []
    var friendRequestsReceived: [User] = []
    var resultsFriendsFromSearching: [SearchableRecordDelegate] = []
    var imageProfile: UIImage?
    
    private var imageCache = NSCache<NSString, UIImage>()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        friendSearchBar.delegate = self
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        friendSearchBar.selectedScopeButtonIndex = 0
        setAppearance()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            print("----------------- resultsFriendsFromSearching.count:: \(resultsFriendsFromSearching.count)-----------------")
            return resultsFriendsFromSearching.count
        } else {
            switch friendSearchBar.selectedScopeButtonIndex {
            case 0:
                return friends.count
            case 1:
                return friendRequestsSent.count
            case 2:
                return friendRequestsReceived.count
            default:
                return 0
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        if isSearching {
            guard let userCell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserTableViewCell else {return UITableViewCell()}
            guard let user = resultsFriendsFromSearching[indexPath.row] as? User else {return UITableViewCell()}
            userCell.delegate = self
            userCell.updateView(user: user)

            if let image = imageCache.object(forKey: user.uuid as NSString) {
                userCell.profileImage.image = image
                print("used cache")

            } else {
                StorageController.shared.getImage(user: user) { (results) in
                    DispatchQueue.main.async {
                        switch results {
                        case .success(let image):
                            userCell.profileImage.image = image
                            self.imageCache.setObject(image, forKey: user.uuid as NSString)
                        case .failure(let error):
                            print("\n==== ERROR IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                        }
                    }
                }
            }
            
            returnCell = userCell
        } else if friendSearchBar.selectedScopeButtonIndex == 0 {
            guard let friendCell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendTableViewCell else {return UITableViewCell()}
            let friend = friends[indexPath.row]
            friendCell.delegate = self
            friendCell.updateView(friend: friend)
            
            if let image = imageCache.object(forKey: friend.uuid as NSString) {
                friendCell.profileImage.image = image
                print("used cache")

            } else {
                StorageController.shared.getImage(user: friend) { (results) in
                    DispatchQueue.main.async {
                        switch results {
                        case .success(let image):
                            friendCell.profileImage.image = image
                            self.imageCache.setObject(image, forKey: friend.uuid as NSString)
                        case .failure(let error):
                            print("\n==== ERROR IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                        }
                    }
                }
            }
            
            
            returnCell = friendCell
        } else if friendSearchBar.selectedScopeButtonIndex == 1 {
            guard let requestCell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as? RequestTableViewCell else {return UITableViewCell()}
            let friendRequestSent = friendRequestsSent[indexPath.row]
            requestCell.delegate = self
            requestCell.updateView(friendRequestSent: friendRequestSent)
            
            if let image = imageCache.object(forKey: friendRequestSent.uuid as NSString) {
                requestCell.profileImage.image = image
                print("used cache")

            } else {
                StorageController.shared.getImage(user: friendRequestSent) { (results) in
                    DispatchQueue.main.async {
                        switch results {
                        case .success(let image):
                            requestCell.profileImage.image = image
                            self.imageCache.setObject(image, forKey: friendRequestSent.uuid as NSString)
                        case .failure(let error):
                            print("\n==== ERROR IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                        }
                    }
                }
            }
            
            returnCell = requestCell
        } else if friendSearchBar.selectedScopeButtonIndex == 2 {
            guard let receivedCell = tableView.dequeueReusableCell(withIdentifier: "receievedCell", for: indexPath) as? ReceivedTableViewCell else {return UITableViewCell()}
            let friendReceived = friendRequestsReceived[indexPath.row]
            receivedCell.delegate = self
            receivedCell.updateView(friendRequestReceived: friendReceived)
            
            if let image = imageCache.object(forKey: friendReceived.uuid as NSString) {
                print("used cache")
                receivedCell.profileImage.image = image
            } else {
                StorageController.shared.getImage(user: friendReceived) { (results) in
                    DispatchQueue.main.async {
                        switch results {
                        case .success(let image):
                            receivedCell.profileImage.image = image
                            self.imageCache.setObject(image, forKey: friendReceived.uuid as NSString)
                        case .failure(let error):
                            print("\n==== ERROR IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                        }
                    }
                }
            }
            
            returnCell = receivedCell
        }
        return returnCell
    }
}

// MARK: - UISearchBarDelegate
extension FriendListTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            isSearching = true
            fetchUsersBySearchTerm(searchTerm: searchText)
           resultsFriendsFromSearching = users
            tableView.reloadData()
        } else {
            resultsFriendsFromSearching = []
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print(selectedScope)
        if selectedScope == 0 {
            self.setupViewForFriends()
            tableView.reloadData()
        } else if selectedScope == 1 {
            self.setupViewForFriendRequestsSent()
            tableView.reloadData()
        } else {
            self.setupViewForFriendRequestsReceived()
            tableView.reloadData()
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsScopeBar = false
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsScopeBar = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        isSearching = false
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearching = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearching = false
    }
}

// MARK: - Helper Fuctions
extension FriendListTableViewController {
    func setupTableView() {
        // fetchAllUsers()
        switch friendSearchBar.selectedScopeButtonIndex {
        case 0:
            setupViewForFriends()
        case 1:
            setupViewForFriendRequestsSent()
        case 2:
            setupViewForFriendRequestsReceived()
        default:
            tableView.reloadData()
        }
    }
    
    func fetchAllUsers() {
        UserController.shared.fetchAllUsers { [weak self] (results) in
            switch results {
            case .success(let users):
                self?.users = users
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    
    func fetchUsersBySearchTerm(searchTerm: String) {
        UserController.shared.fetchSpecificUsersBySearchTerm(searchTerm: searchTerm) { [weak self] (results) in
            switch results {
            case .success(let users):
                self?.users = users
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    
    func setupViewForFriends() {
        guard let currentUser = UserController.shared.currentUser else {return print("no user logged in")}
        UserController.shared.fetchFriendsFor(currentUser: currentUser) { [weak self] (results) in
            switch results {
            case .success(let fetchFriends):
                self?.friends = fetchFriends
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    func setupViewForFriendRequestsSent() {
        guard let currentUser = UserController.shared.currentUser else {return print("no user logged in")}
        UserController.shared.fetchPendingFriendRequestsSentBy(currentUser: currentUser) { [weak self] (results) in
            switch results {
            case .success(let pendingFriendRequests):
                self?.friendRequestsSent = pendingFriendRequests
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    func setupViewForFriendRequestsReceived() {
        guard let currentUser = UserController.shared.currentUser else {return print("no user logged in")}
        UserController.shared.fetchFriendRequestsReceived(currentUser: currentUser) { [weak self] (results) in
            switch results {
            case .success(let friendsReceived):
                self?.friendRequestsReceived = friendsReceived
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
}

// MARK: - Protocol
extension FriendListTableViewController: FriendTableViewCellCellDelagate {
    func blockFriendButtonTapped(sender: FriendTableViewCell) {
        let alertController = UIAlertController(title: "Are you sure to block this user?", message: "If you blocked this user, you will be not able to associate with this user anymore.", preferredStyle: .alert)
        
        let blockedAction = UIAlertAction(title: "Block!", style: .destructive) { (_) in
            guard let indexPath = self.tableView.indexPath(for: sender) else {return}
            let friendToBlock = self.friends[indexPath.row]
                   //TO BLOCK FRIEND HERE...
                   UserController.shared.blockUser(friendToBlock) { [weak self] (results) in
                       DispatchQueue.main.async {
                           switch results {
                           case .success(let user):
                               guard let indexToBlock = self?.friends.firstIndex(of: user) else {return}
                               self?.friends.remove(at: indexToBlock)
                               self?.tableView.reloadData()
                           //self?.setupViewForFriends()
                           case .failure(let error):
                               print("ERROR IN BLOCKING FRIEND in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                           }
                       }
                   }

        }
        let dismissAction = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(dismissAction)
        alertController.addAction(blockedAction)
        present(alertController, animated: true)
    }
    
    func unfriendButtonTapped(sender: FriendTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else {return}
        let friendToUnfriend = self.friends[indexPath.row]
        UserController.shared.unfriendUser(friendToUnfriend) { [weak self] (results) in
            DispatchQueue.main.async {
                switch results {
                case .success(let user):
                    guard let indexToUnfriend = self?.friends.firstIndex(of: user) else {return}
                    self?.friends.remove(at: indexToUnfriend)
                    // self?.tableView.deleteRows(at: [indexPath], with: .fade)
                    self?.tableView.reloadData()
                //  self?.setupViewForFriends()
                case .failure(let error):
                    print("ERROR IN BLOCKING FRIEND in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
}

// MARK: - RequestTableViewCellDelagate Protocol
extension FriendListTableViewController: RequestTableViewCellDelagate {
    func cancelFriendRequestButtonTapped(sender: RequestTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else {return}
        let friendToCancelRequest = friendRequestsSent[indexPath.row]
        UserController.shared.cancelFriendRequest(to: friendToCancelRequest) { [weak self] (results) in
            DispatchQueue.main.async {
                switch results {
                case .success(let friendToCancelRequest):
                    guard let indexOfRequestCancel = self?.friendRequestsSent.firstIndex(of: friendToCancelRequest) else {return}
                    self?.friendRequestsSent.remove(at: indexOfRequestCancel)
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("ERROR CANCEL FRIEND REQUEST in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
}

// MARK: - ReceivedTableViewCellDelagate Protocol
extension FriendListTableViewController: ReceivedTableViewCellDelagate {
    func acceptFriendButtonTapped(sender: ReceivedTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else {return}
        let friendsToAccept = friendRequestsReceived[indexPath.row]
        UserController.shared.acceptFriendRequest(user: friendsToAccept) { [weak self] (results) in
            DispatchQueue.main.async {
                switch results {
                case .success(let friend):
                    guard let indexOFfriendToRemove = self?.friendRequestsReceived.firstIndex(of: friend) else {return}
                    self?.friendRequestsReceived.remove(at: indexOFfriendToRemove)
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("ERROR ACCEPTING FRIEND IN \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
}

// MARK: - UserTableViewCellDelagate Protocol
extension FriendListTableViewController: UserTableViewCellDelagate {
    func requestButtonTapped(sender: UserTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else {return}
        guard let userToRequest = resultsFriendsFromSearching[indexPath.row] as? User else {return}
        UserController.shared.sendFriendRequest(to: userToRequest) { [weak self] (results) in
            switch results {
            case .success(let userToRequest):
                DispatchQueue.main.async {
                    self?.presentAlertToUser(titleAlert: "Friend Request Sent!", messageAlert: "You just request \(userToRequest.userName) to be your friend!")
                    self?.friendSearchBar.searchTextField.text = ""
                    print("===== SUCCESSFULLY SENT FRIEND REQUEST!! Current User is requesting \(userToRequest.firstName) to be a friend. \(#function)======")
                }
            case .failure(let error):
                self?.presentAlertToUser(titleAlert: "Error! Friend Request Sent!", messageAlert: "You have already sent friend request to \(userToRequest.userName)! Please, just wait for \(userToRequest.userName) to accept you as a friend.")
                print("ERROR REQUESTING FRIEND in  \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
}

