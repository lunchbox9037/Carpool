//
//  LogInViewController.swift
//  DriveTribe
//
//  Created by Lee McCormick on 3/22/21.
//

import UIKit

class LogInViewController: UIViewController {
    
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPassWordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        guard let email = loginEmailTextField.text, !email.isEmpty,
              let password = loginPassWordTextField.text, !password.isEmpty else {return}
        
        UserController.shared.loginWith(email: email, password: password) { (results) in
            switch results {
            case .success(let results):
                print("This is email of loggin user : \(results)")
                self.gotoFriendListVC()
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        
    }
    
    
    // MARK: - Helper Fuctions
    func gotoFriendListVC() {
        let storyboard = UIStoryboard(name: "FriendsList", bundle: nil)
        let  vc = storyboard.instantiateViewController(identifier: "friendListVCStoryboardID")
        vc.modalPresentationStyle = .pageSheet
        self.present( vc, animated: true, completion: nil)
    }
    
    

}
