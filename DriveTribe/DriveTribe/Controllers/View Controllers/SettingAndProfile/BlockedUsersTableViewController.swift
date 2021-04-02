//
//  BlockedUsersTableViewController.swift
//  DriveTribe
//
//  Created by Dennis High on 3/24/21.
//

import UIKit

class BlockedUsersTableViewController: UITableViewController {

    var blockedUsers: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
        setAppearance()
    }
    
    
    // MARK: - Table view data source
    func setupViews() {
        guard let currentUser = UserController.shared.currentUser else {return}
        UserController.shared.fetchBlockedUsersByCurrentUser(currentUser) { (results) in
            DispatchQueue.main.async {
            switch results {
            case .success(let fetchBlockedUserForCurrentUser):
                self.blockedUsers = fetchBlockedUserForCurrentUser
                self.tableView.reloadData()
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
                
            }
        }
    }
}

extension BlockedUsersTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("-----------------blockedUsers.count :: \(blockedUsers.count)-----------------")
        return blockedUsers.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "blockedFriendCell") as? BlockedUserTableViewCell else {return UITableViewCell()}
        let blockedUser = blockedUsers[indexPath.row]
        cell.updateView(blockedUser: blockedUser)
        StorageController.shared.getImage(user: blockedUser) { (results) in
            DispatchQueue.main.async {
                switch results {
                case .success(let image):
                    cell.profileImageView.image = image
                case .failure(let error):
                    print("\n==== ERROR IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                }
            }
        }
        cell.delegate = self
        return cell
    }
}

extension BlockedUsersTableViewController: BlockedFriendTableViewCellDelegate {
    func unblockFriendButtonTapped(sender: BlockedUserTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else {return}
        let userToUnBlock = blockedUsers[indexPath.row]
        //TO UNBLOCK FRIEND HERE...
        UserController.shared.unblockedUser(userToUnBlock) { [weak self] (results) in
            DispatchQueue.main.async {
                switch results {
                case .success(let user):
                    print("====\(user.firstName)==== GOT UNBLOCK")
                    guard let indexToUnblock = self?.blockedUsers.firstIndex(of: user) else {return}
                    self?.blockedUsers.remove(at: indexToUnblock)
                    self?.tableView.deleteRows(at: [indexPath], with: .fade)
                    self?.tableView.reloadData()
                    self?.setupViews()
                case .failure(let error):
                    print("ERROR IN UNBLOCKING USER in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
}

