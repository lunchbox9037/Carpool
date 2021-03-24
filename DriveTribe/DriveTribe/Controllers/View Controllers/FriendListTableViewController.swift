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
//    var currentUser: User?
    var imageProfile: UIImage?

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
            userCell.updateView(user: user)
            StorageController.shared.getImage(user: user) { (results) in
                DispatchQueue.main.async {
                    switch results {
                    case .success(let image):
                        userCell.profileImage.image = image
                    case .failure(let error):
                        print("\n==== ERROR IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                    }
                }
            }
            userCell.delegate = self
            returnCell = userCell
        } else if friendSearchBar.selectedScopeButtonIndex == 0 {
            guard let friendCell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendTableViewCell else {return UITableViewCell()}
            let friend = friends[indexPath.row]
            friendCell.updateView(friend: friend)
            StorageController.shared.getImage(user: friend) { (results) in
                DispatchQueue.main.async {
                    switch results {
                    case .success(let image):
                        friendCell.profileImage.image = image
                    case .failure(let error):
                        print("\n==== ERROR IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                    }
                }
            }
            
            
            friendCell.delegate = self
            returnCell = friendCell
        } else if friendSearchBar.selectedScopeButtonIndex == 1 {
            guard let requestCell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as? RequestTableViewCell else {return UITableViewCell()}
            let friendRequestSent = friendRequestsSent[indexPath.row]
            requestCell.updateView(friendRequestSent: friendRequestSent)
            StorageController.shared.getImage(user: friendRequestSent) { (results) in
                DispatchQueue.main.async {
                    switch results {
                    case .success(let image):
                        requestCell.profileImage.image = image
                    case .failure(let error):
                        print("\n==== ERROR IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                    }
                }
            }
            requestCell.delegate = self
            returnCell = requestCell
        } else if friendSearchBar.selectedScopeButtonIndex == 2 {
            guard let receivedCell = tableView.dequeueReusableCell(withIdentifier: "receievedCell", for: indexPath) as? ReceivedTableViewCell else {return UITableViewCell()}
            let friendReceived = friendRequestsReceived[indexPath.row]
            receivedCell.updateView(friendRequestReceived: friendReceived)
            StorageController.shared.getImage(user: friendReceived) { (results) in
                DispatchQueue.main.async {
                    switch results {
                    case .success(let image):
                        receivedCell.profileImage.image = image
                    case .failure(let error):
                        print("\n==== ERROR IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                    }
                }
            }
            receivedCell.delegate = self
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
            fetchAllUsers()
            resultsFriendsFromSearching = users.filter{$0.matches(searchTerm: searchText, username: $0.userName)}
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
        fetchAllUsers()
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
            
//            UserController.shared.fetchCurrentUser { [weak self] (results) in
//                switch results {
//                case .success(let currentUser):
//                    self?.currentUser = currentUser
//                case .failure(let error):
//                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
//                }
//            }
        }
    }
    
    func setupViewForFriends() {
//        UserController.shared.fetchCurrentUser { [weak self] (results) in
//            DispatchQueue.main.async {
//                switch results {
//                case .success(let currenUser):
//                    self?.currentUser = currenUser
//
//                case .failure(let error):
//                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
//                }
//            }
//        }
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
//        UserController.shared.fetchCurrentUser { [weak self] (results) in
//            DispatchQueue.main.async {
//                switch results {
//                case .success(let currenUser):
//                    self?.currentUser = currenUser
//
//                case .failure(let error):
//                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
//                }
//            }
//        }
        
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
//        UserController.shared.fetchCurrentUser { [weak self] (results) in
//            DispatchQueue.main.async {
//                switch results {
//                case .success(let currenUser):
//                    self?.currentUser = currenUser
//
//                case .failure(let error):
//                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
//                }
//            }
//        }
        
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
    
    func unfriendButtonTapped(sender: FriendTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else {return}
        let friendToUnfriend = self.friends[indexPath.row]
        UserController.shared.unfriendUser(friendToUnfriend) { [weak self] (results) in
            DispatchQueue.main.async {
                switch results {
                case .success(let user):
//                    print("====\(user.firstName)==== GOT UNFRIENDED FROM \(self?.currentUser?.firstName ?? "").")
                    guard let indexToUnfriend = self?.friends.firstIndex(of: user) else {return}
                    self?.friends.remove(at: indexToUnfriend)
                    self?.tableView.deleteRows(at: [indexPath], with: .fade)
                    self?.tableView.reloadData()
                    self?.setupViewForFriends()
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
//                    print("SUCCESSFULLY CANCEL \(friendToCancelRequest.firstName) FROM \(self?.currentUser?.firstName ?? "")'S LIST.")
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
        UserController.shared.sendFriendRequest(to: userToRequest) { (results) in
            switch results {
            case .success(let userToRequest):
                print("===== SUCCESSFULLY SENT FRIEND REQUEST!! Current User is requesting \(userToRequest.firstName) to be a friend. \(#function)======")
            case .failure(let error):
                print("ERROR REQUESTING FRIEND in  \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
}



/* NOTE
 
 UI BUG
 1) Friend Tap ==> When tapped unfriend, the friendToUnfriend did not get delete from tableView
 
 //______________________________________________________________________________________
 */
