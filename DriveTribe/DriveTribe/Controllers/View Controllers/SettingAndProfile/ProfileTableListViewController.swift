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
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var lastNameTextFiled: UITextField!
    @IBOutlet weak var carInfoTextField: UITextField!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    @IBOutlet weak var updatePhotoButton: UIButton!
    
    // MARK: - properties
    var isEditingProfile = false
    var selectedImage: UIImage?
 
    // MARK: - lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        print("I am here")
        profileImageView.setupRoundCircleViews()
        guard let currentUser = UserController.shared.currentUser else {return}
        lastNameTextFiled.delegate = self
        carInfoTextField.delegate = self
        userNameTextField.delegate = self
        firstNameTextField.delegate = self
        
        StorageController.shared.getImage(user: currentUser) { [weak self] (results) in
            
            switch results {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.profileImageView.image = image
                }
            case .failure(let error):
                print("\n==== ERROR IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
            }
        }
        firstNameTextField.isUserInteractionEnabled = false
        userNameTextField.isUserInteractionEnabled = false
        lastNameTextFiled.isUserInteractionEnabled = false
        carInfoTextField.isUserInteractionEnabled = false
        populateViews()
        updatePhotoButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAppearance()
    }
    
    
    @IBAction func updatePhotoButtonTapped(_ sender: Any) {
        if  updatePhotoButton.isEnabled {
            presentImagePickerActionSheet()
        } else {
            print("GO TAPPED EDITTED BUTTON")
        }
    }
    
    func populateViews() {
        guard let user = UserController.shared.currentUser else { return }
        self.userNameTextField.text = user.userName
        self.firstNameTextField.text = user.firstName
        self.lastNameTextFiled.text = user.lastName
        self.carInfoTextField.text = user.carInfo
    }
    
    @IBAction func editedButtonTapped(_ sender: Any) {
        self.isEditingProfile.toggle()
        if isEditingProfile {
            updatePhotoButton.isEnabled = true
            editButton.title = "Save"
            firstNameTextField.isUserInteractionEnabled = true
            userNameTextField.isUserInteractionEnabled = true
            lastNameTextFiled.isUserInteractionEnabled = true
            carInfoTextField.isUserInteractionEnabled = true
        } else {
            updatePhotoButton.isEnabled = false
            guard let username = userNameTextField.text, !username.isEmpty,
                  let firstName = firstNameTextField.text, !firstName.isEmpty,
                  let lastName = lastNameTextFiled.text, !lastName.isEmpty else {
                presentAlertToUser(titleAlert: "Info updated needed!", messageAlert: "Please, fill out your usename, first name and last name for updating for infomation!")
                return
            }
            let carInfo = carInfoTextField.text
            UserController.shared.updateUserProfile(firstName: firstName, lastName: lastName, userName: username, carInfo: carInfo ?? "") { [weak self] (results) in
                switch results {
                case .success(let success):
                    DispatchQueue.main.async {
                        print(success)
                        self?.editButton.title = "Edit"
                        self?.firstNameTextField.isUserInteractionEnabled = false
                        self?.userNameTextField.isUserInteractionEnabled = false
                        self?.lastNameTextFiled.isUserInteractionEnabled = false
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
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
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

extension ProfileTableListViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == userNameTextField) {
            textField.text = ""
        } else if (textField == firstNameTextField) {
            textField.text = ""
        } else if (textField == lastNameTextFiled) {
            textField.text = ""
        } else if (textField == carInfoTextField) {
            textField.text = ""
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

extension ProfileTableListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.selectedImage = photo
            self.profileImageView.image = photo
            guard let currentUser = UserController.shared.currentUser else {return}
            guard let selectedImage = selectedImage else {
                print("NO SELECETED IMAGE")
                return
            }
            StorageController.shared.storeImage(user: currentUser, image: selectedImage) { (results) in
                switch results {
                case .success(let url):
                    print("url : \(url)")
                    print("SUCCESSFULLY! TRY TO UPDATE IMAGE!")
                case .failure(_):
                    print("ERROR TRYING TO UPDETE IMAGE!")
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func presentImagePickerActionSheet() {
        let imagePickerController = UIImagePickerController()
        
        let actionSheet = UIAlertController(title: "Update Profile Picture", message: "Select or take a photo for your profile.", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            actionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { [weak self] (_) in
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = self
                imagePickerController.allowsEditing = true
                self?.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] (_) in
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                imagePickerController.allowsEditing = true
                self?.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
}
