//
//  LogInViewController.swift
//  DriveTribe
//
//  Created by Lee McCormick on 3/22/21.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class LogInViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "driveTribeIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.keyboardType = .emailAddress
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemGray.cgColor
        field.attributedPlaceholder = NSAttributedString(string: "Email...",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.dtPlaceholder!])
        field.textColor = .black
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.keyboardType = .default
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemGray.cgColor
        field.attributedPlaceholder = NSAttributedString(string: "Password...",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.dtPlaceholder!])
        field.textColor = .black
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = UIColor(named: "loginButtonColor")
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
    
    let spinner = JGProgressHUD(style: .dark)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .dtBlueTribe
        
        setupToHideKeyboardOnTapOnView()
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        autoLogin()
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
    
    func autoLogin() {
        if Auth.auth().currentUser != nil {
            self.spinner.textLabel.text = "Signing In"
            self.spinner.show(in: self.view)
            UserController.shared.fetchCurrentUser { [weak self] (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self?.gotoTabbarVC()
                    case .failure(let error):
                        self?.spinner.dismiss(animated: true)
                        self?.presentAlertToUser(titleAlert: "Error", messageAlert: "\(error.localizedDescription)")
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
            presentAlertToUser(titleAlert: "Login information invalid!", messageAlert: "Password must be at least six characters!")
            return
        }
        spinner.textLabel.text = "Signing In"
        spinner.show(in: view)
        UserController.shared.loginWith(email: email, password: password) { [weak self] (results) in
            DispatchQueue.main.async {
                switch results {
                case .success(let results):
                    print("This is email of loggin user : \(results)")
                    UserController.shared.fetchCurrentUser { [weak self] (result) in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(_):
                                self?.spinner.dismiss(animated: true)
                                self?.gotoTabbarVC()
                            case .failure(let error):
                                self?.spinner.dismiss()
                                print(error.localizedDescription)
                            }
                        }
                    }
                case .failure(let error):
                    self?.spinner.dismiss(animated: true)
                    self?.presentAlertToUser(titleAlert: "Login information invalid!", messageAlert: "Invalid Username or Password")
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    // MARK: - Helper Fuctions
    func gotoTabbarVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let  vc = storyboard.instantiateViewController(identifier: "tabBarStoryBoardID")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.scrollView.contentSize = CGSize(width: view.width, height: view.height + (view.height * 0.25))
    }
}
