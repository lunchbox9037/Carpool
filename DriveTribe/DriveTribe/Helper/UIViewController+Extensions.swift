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
    
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func setAppearance() {
        let defaults = UserDefaults.standard
        let appearanceSelection = defaults.integer(forKey: "modeAppearance")
        
        if appearanceSelection == 0 {
            overrideUserInterfaceStyle = .light
        } else if appearanceSelection == 1 {
            overrideUserInterfaceStyle = .dark
        }
    }
}



extension UIView {
    func addCornerRadius(radius: CGFloat = 6) {
        self.layer.cornerRadius = radius
    }
    
    func rotate(by radians: CGFloat = -CGFloat.pi / 2) {
        self.transform = CGAffineTransform(rotationAngle: radians)
    }
    
    // MARK: - Helper Fuctions
    func setupRoundCircleViews() {
//        self.layer.cornerRadius = self.frame.height / 2
//        self.clipsToBounds = true
        
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
}
