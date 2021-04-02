//
//  UIViewController+Extensions.swift
//  DriveTribe
//
//  Created by Lee McCormick on 3/23/21.
//

import UIKit

extension UIViewController {
    func presentAlertToUser(titleAlert: String, messageAlert: String) {
        let alertController = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .actionSheet)
        let dismissAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
    
    func presentFirstLoginAlert() {
        let alertController = UIAlertController(title: "Welcome to RideTribe!", message: "Add friends to start creating tribes.\nOnce you have a few friends tap the plus button to create a tribe and begin chatting.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
    
    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setAppearance() {
        let defaults = UserDefaults.standard
        let appearanceSelection = defaults.integer(forKey: "modeAppearance")
        self.view.backgroundColor = .dtBackground
        
        if appearanceSelection == 0 {
            overrideUserInterfaceStyle = .light
        } else if appearanceSelection == 1 {
            overrideUserInterfaceStyle = .dark
        }
    }
}

extension UIView {
    func addCornerRadius(radius: CGFloat = 8) {
        self.layer.cornerRadius = radius
    }
    
    func rotate(by radians: CGFloat = -CGFloat.pi / 2) {
        self.transform = CGAffineTransform(rotationAngle: radians)
    }
    
    // MARK: - Helper Fuctions
    func setupRoundCircleViews() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
}
