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
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var logOutButton: UIButton!
    
    // MARK: - properties
    var isEditingProfile = false
    
    
    // MARK: - lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        print("I am here")
        guard let currentUser = UserController.shared.currentUser else {return}
        
        StorageController.shared.getImage(user: currentUser) { (results) in
            
            switch results {
            case .success(let image):
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            case .failure(let error):
                print("\n==== ERROR IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
            }
        }
        usernameTextField.isUserInteractionEnabled = false
        nameTextField.isUserInteractionEnabled = false
        lastNameTextField.isUserInteractionEnabled = false
        carInfoTextField.isUserInteractionEnabled = false
        populateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAppearance()
    }
    
    func populateViews() {
        guard let user = UserController.shared.currentUser else { return }
        self.usernameTextField.text = user.userName
        self.nameTextField.text = user.firstName
        self.lastNameTextField.text = user.lastName
        
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        self.isEditingProfile.toggle()
        if isEditingProfile {
            editButton.title = "Save"
            usernameTextField.isUserInteractionEnabled = true
            nameTextField.isUserInteractionEnabled = true
            lastNameTextField.isUserInteractionEnabled = true
            carInfoTextField.isUserInteractionEnabled = true
            
        } else {
            
            guard let username = usernameTextField.text, !username.isEmpty,
                  let firstName = nameTextField.text, !firstName.isEmpty,
                  let lastName = lastNameTextField.text, !lastName.isEmpty else {
                // present alert here
                return
                
            }
            let carInfo = carInfoTextField.text
            UserController.shared.updateUserProfile(firstName: firstName, lastName: lastName, userName: username, carInfo: carInfo ?? "") { (results) in
                switch results {
                
                case .success(let success):
                    DispatchQueue.main.async {
                        print(success)
                        self.editButton.title = "Edit"
                        self.usernameTextField.isUserInteractionEnabled = false
                        self.nameTextField.isUserInteractionEnabled = false
                        self.lastNameTextField.isUserInteractionEnabled = false
                        self.carInfoTextField.isUserInteractionEnabled = false
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                // present error alert
                }
            }
            
            
        }
    }
    
    func gotoLogginVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let  vc = storyboard.instantiateViewController(identifier: "logginStoryBoardID")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        UserController.shared.logout { (results) in
            switch results {
            
            case .success(let response):
                self.gotoLogginVC()
                print(response)
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    
/*
    func deleteUser() {
        guard let currentUser = UserController.shared.currentUser else {return}
        UserController.shared.deleteUser(currentUser: currentUser) { (results) in
            switch results {
            case .success(let user):
                 print("\n===== SUCCESSFULLY! DELETED \(user) ACCOUNT FROM THE APP.===== \(#function)\n")
            case .failure(let error):
                print("\n==== ERROR IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
            }
        }
    }
 */
}
