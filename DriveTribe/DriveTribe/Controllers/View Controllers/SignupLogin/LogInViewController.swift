//
//  LogInViewController.swift
//  DriveTribe
//
//  Created by Lee McCormick on 3/22/21.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPassWordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupToHideKeyboardOnTapOnView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser != nil {
          gotoTabbarVC()
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        guard let email = loginEmailTextField.text, !email.isEmpty,
              let password = loginPassWordTextField.text, !password.isEmpty else {return}
        
        UserController.shared.loginWith(email: email, password: password) { (results) in
            switch results {
            case .success(let results):
                print("This is email of loggin user : \(results)")
                self.gotoTabbarVC()
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        
    }
    
    
    
    @IBAction func signupbuttonTapped(_ sender: Any) {
        
        gotoSignInVC()
    }
    
    
    
    // MARK: - Helper Fuctions
    func gotoTabbarVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let  vc = storyboard.instantiateViewController(identifier: "tabBarStoryBoardID")
        self.present(vc, animated: true, completion: nil)
    }
    
    func gotoSignInVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let  vc = storyboard.instantiateViewController(identifier: "signInStoryboardID")
        self.present( vc, animated: true, completion: nil)
    }
}
