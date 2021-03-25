//
//  LogInViewController.swift
//  DriveTribe
//
//  Created by Lee McCormick on 3/22/21.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemGray.cgColor
        field.placeholder = "Email Address..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .systemBackground
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemGray.cgColor
        field.placeholder = "Password..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .systemBackground
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up!", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupToHideKeyboardOnTapOnView()
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
//        signUpButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
//        scrollView.addSubview(signUpButton)
        
        scrollView.isUserInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let size = view.width/2
        imageView.frame = CGRect(x: (scrollView.width-size)/2, y: 24, width: size, height: size)
        emailField.frame = CGRect(x: 30, y: imageView.bottom + 10, width: scrollView.width-60, height: 44)
        passwordField.frame = CGRect(x: 30, y: emailField.bottom + 10, width: scrollView.width-60, height: 44)
        loginButton.frame = CGRect(x: 30, y: passwordField.bottom + 10, width: scrollView.width-60, height: 44)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser != nil {
            print("logged in")
            UserController.shared.fetchCurrentUser { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self.gotoTabbarVC()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    @objc func loginButtonTapped() {
        view.endEditing(true)
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty, password.count >= 6 else {
            presentAlertToUser(titleAlert: "Login information invalid.", messageAlert: "Please enter a valid username and password!")
            return
        }

        UserController.shared.loginWith(email: email, password: password) { (results) in
            switch results {
            case .success(let results):
                print("This is email of loggin user : \(results)")
                UserController.shared.fetchCurrentUser { (result) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(_):
                            self.gotoTabbarVC()
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
//    @objc func signupButtonTapped() {
//        gotoSignInVC()
//    }
    
    // MARK: - Helper Fuctions
    func gotoTabbarVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let  vc = storyboard.instantiateViewController(identifier: "tabBarStoryBoardID")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func gotoSignInVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let  vc = storyboard.instantiateViewController(identifier: "signInStoryboardID")
        vc.modalPresentationStyle = .fullScreen
        self.present( vc, animated: true, completion: nil)
    }
}//end class

// MARK: - Textfield delegate extension
extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            loginButtonTapped()
        }
        return true
    }
}
