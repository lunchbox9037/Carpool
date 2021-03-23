//
//  SignupViewController.swift
//  DriveTribe
//
//  Created by Lee McCormick on 3/18/21.
//

import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var signupFirstNameTextField: UITextField!
    @IBOutlet weak var signupLastNameTextField: UITextField!
    @IBOutlet weak var signupUserNameTextField: UITextField!
    @IBOutlet weak var signupEmailTextField: UITextField!
    @IBOutlet weak var signupPasswordTextField: UITextField!
    
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    
    @IBAction func realSignupButtonTapped(_ sender: Any) {
        guard let firstName = signupFirstNameTextField.text, !firstName.isEmpty,
              let lastName = signupLastNameTextField.text, !lastName.isEmpty,
              let userName = signupUserNameTextField.text, !userName.isEmpty,
              let email = signupEmailTextField.text, !email.isEmpty,
              let password = signupPasswordTextField.text, !password.isEmpty else {return}
        
        UserController.shared.signupNewUserAndCreateNewContactWith(firstName: firstName, lastName: lastName, userName: userName, email: email, password: password) { (results) in
            switch results {
            case .success(let user):
                if let image = self.selectedImage {
                    print("----------------- IN SIDE SELECTED IMAGE:: \(image) \(#function)-----------------")
                    self.storageProfilePhotAndgetProfileURL(user: user, image: image)
                }
                self.gotoFriendListVC()
            case .failure(let error):
                print("ERROR SIGNING UP USER : \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    func storageProfilePhotAndgetProfileURL(user: User, image: UIImage) {
        StorageController.shared.storeImage(user: user, image: image) { (results) in
            switch results {
            case .success(let url):
                print("-----------------URL :: \(url)-----------------")
            case .failure(let error):
                print("\n==== ERROR IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
            }
        }
    }
    
    @IBAction func addAddressButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: - Helper Fuctions
    func gotoFriendListVC() {
        let storyboard = UIStoryboard(name: "FriendsList", bundle: nil)
        let  vc = storyboard.instantiateViewController(identifier: "friendListVCStoryboardID")
        vc.modalPresentationStyle = .pageSheet
        self.present( vc, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoPickerVC" {
            guard let destinationVC = segue.destination as? PhotoPickerViewController else {return}
            destinationVC.delegate = self
        }
    }
}

extension SignupViewController: PhotoSelectorViewControllerDelegate {
    func photoSelectorViewControllerSelected(image: UIImage) {
        self.selectedImage = image
    }
}


