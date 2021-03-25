//
//  ProfileTableListViewController.swift
//  DriveTribe
//
//  Created by Lee McCormick on 3/24/21.
//

import UIKit

class ProfileTableListViewController: UITableViewController {

   
    // MARK: - outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var carInfoTextField: UITextField!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    // MARK: - properties
    var isEditingProfile = false
    
    
    // MARK: - lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        print("I am here")
        profileImageView.setupRoundCircleViews()
        guard let currentUser = UserController.shared.currentUser else {return}
        
        StorageController.shared.getImage(user: currentUser) { [weak self] (results) in
            
            switch results {
            case .success(let image):
                DispatchQueue.main.async {
                  //  self?.profileImageView.setupRoundCircleViews()
                    self?.profileImageView.image = image
                    
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
    
    
    
    @IBAction func editedButtonTapped(_ sender: Any) {
        
        self.isEditingProfile.toggle()
        if isEditingProfile {
            editButton.setTitle("Save Profile Info", for: .normal)
            usernameTextField.isUserInteractionEnabled = true
            nameTextField.isUserInteractionEnabled = true
            lastNameTextField.isUserInteractionEnabled = true
            carInfoTextField.isUserInteractionEnabled = true
        } else {
            guard let username = usernameTextField.text, !username.isEmpty,
                  let firstName = nameTextField.text, !firstName.isEmpty,
                  let lastName = lastNameTextField.text, !lastName.isEmpty else {
                presentAlertToUser(titleAlert: "Info updated needed!", messageAlert: "Please, fill out your usename, first name and last name for updating for infomation!")
                return
                
            }
            let carInfo = carInfoTextField.text
            UserController.shared.updateUserProfile(firstName: firstName, lastName: lastName, userName: username, carInfo: carInfo ?? "") { [weak self] (results) in
                switch results {
                case .success(let success):
                    DispatchQueue.main.async {
                        print(success)
                        self?.editButton.setTitle("Edit Profile Info", for: .normal)
                        self?.usernameTextField.isUserInteractionEnabled = false
                        self?.nameTextField.isUserInteractionEnabled = false
                        self?.lastNameTextField.isUserInteractionEnabled = false
                        self?.carInfoTextField.isUserInteractionEnabled = false
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.presentAlertToUser(titleAlert: "Unable to update!", messageAlert: "Sorry, unable to update your profile info!")
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
}
