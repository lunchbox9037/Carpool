//
//  SettingsTableViewController.swift
//  DriveTribe
//
//  Created by Dennis High on 3/24/21.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var blockedUsersButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteAccountButton.addCornerRadius()
        blockedUsersButton.addCornerRadius()
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
    
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        deleteUser()
        gotoLogginVC()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [1,0]:
            promptRating()
            tableView.deselectRow(at: indexPath, animated: true)
        case [2,0]:
            launchShareSheet()
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            return
        }
    }
    
    func deleteUser() {
        guard let currentUser = UserController.shared.currentUser else {return}
        UserController.shared.deleteUser(currentUser: currentUser) { (results) in
            switch results {
            case .success(let user):
                print("\n===== Successfully Deleted User \(user) Account from App.===== \(#function) ====\n")
                
            case .failure(let error):
                print("\n ==== Error in \(#function) : \(error.localizedDescription) : \(error) ====\n")
            }
        }
    }
    
    func gotoLogginVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let  vc = storyboard.instantiateViewController(identifier: "logginStoryBoardID")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
