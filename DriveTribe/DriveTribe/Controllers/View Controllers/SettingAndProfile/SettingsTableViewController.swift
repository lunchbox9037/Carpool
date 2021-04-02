//
//  SettingsTableViewController.swift
//  DriveTribe
//
//  Created by Dennis High on 3/24/21.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAppearance()
    }
    
    func promptRating() {
        if let url = URL(string: "itms-apps://apple.com/app/") {
            UIApplication.shared.open(url)
        } else {
            print("error with app store URL")
        }
    }
    
    func launchShareSheet() {
        if let appURL = NSURL(string: "https://apps.apple.com/us/app") {
            let objectsToShare: [Any] = [appURL]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
            activityVC.popoverPresentationController?.sourceView = tableView
            
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func deleteUser() {
        print("\n=================== DELETE USER ======================IN \(#function)\n")
        let alertController = UIAlertController(title: "Are you sure to delete your account?", message: "If you are going to delete your account, you will automatically log out. The account will be deleted from the database. You will not be able to use this app with this account anymore.", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Sure, Delete Account!", style: .destructive) { (_) in
            guard let currentUser = UserController.shared.currentUser else {return}
            UserController.shared.deleteUser(currentUser: currentUser) { (results) in
                switch results {
                case .success(let user):
                    print("\n===== Successfully Deleted User \(user) Account from App.===== \(#function) ====\n")
                    self.gotoLogginVC()
                    
                case .failure(let error):
                    print("\n ==== Error in \(#function) : \(error.localizedDescription) : \(error) ====\n")
                }
            }
        }
        
        let dismissAction = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(dismissAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true)
    }
    
    func gotoLogginVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let  vc = storyboard.instantiateViewController(identifier: "logginStoryBoardID")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\n===================indexPath :: \(indexPath)======================IN \(#function)\n")
        switch indexPath {
        case [0,0]:
            promptRating()
            tableView.deselectRow(at: indexPath, animated: true)
        case [1,0]:
            launchShareSheet()
            tableView.deselectRow(at: indexPath, animated: true)
        case [2,0]:
            
            tableView.deselectRow(at: indexPath, animated: true)
        case [3,0]:
            deleteUser()
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            return
        }
    }
}
