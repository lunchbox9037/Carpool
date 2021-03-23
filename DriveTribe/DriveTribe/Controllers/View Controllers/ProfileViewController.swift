//
//  ProfileViewController.swift
//  DriveTribe
//
//  Created by Dennis High on 3/19/21.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var carInfoTextField: UITextField!
    
    @IBOutlet weak var editButton: UINavigationItem!
    
    // MARK: - properties
    
    
    // MARK: - lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        print("I am here")
        
        populateViews()
    }
    
    func populateViews() {

        
        
        guard let user = UserController.shared.currentUser else { return }
    
    self.usernameTextField.text = user.userName
    self.nameTextField.text = user.firstName
        self.lastNameTextField.text = user.lastName

    }
    
    
    
    
    
    @IBAction func editButtonTapped(_ sender: Any) {
        usernameTextField.isEditing
    }
    
   
    

}
