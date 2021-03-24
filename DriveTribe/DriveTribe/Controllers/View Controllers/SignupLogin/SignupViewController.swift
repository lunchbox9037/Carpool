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
    @IBOutlet weak var containerView: UIView!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToHideKeyboardOnTapOnView()
        containerView.setupRoundCircleViews()
    }
    
    
    @IBAction func signupButtonTapped(_ sender: Any) {
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
                self.gotoTabbarVC()
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
    
    
    // MARK: - Helper Fuctions
    func gotoTabbarVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let  vc = storyboard.instantiateViewController(identifier: "tabBarStoryBoardID")
        self.present(vc, animated: true, completion: nil)
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
        print("----------------- photoSelectorViewControllerSelected ----------------")
        self.selectedImage = image
    }
}


