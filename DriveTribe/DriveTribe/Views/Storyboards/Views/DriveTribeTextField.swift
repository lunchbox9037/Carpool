//
//  DriveTribeTextField.swift
//  DriveTribe
//
//  Created by Lee on 3/29/21.
//

import UIKit

class DriveTribeTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        updateFont()
    }
    
    func setupView() {
                self.addCornerRadius()
                setupPlaceholderText()
                self.textColor = .dtTextTribe
                self.backgroundColor = .dtLightTribe
                self.layer.borderWidth = 2.5
                self.layer.borderColor = UIColor.dtLightTribe.cgColor
                self.layer.masksToBounds = true
        
        
//        self.addCornerRadius()
//        setupPlaceholderText()
//        self.textColor = .mtTextDarkBrown
//        self.backgroundColor = .mtDarkOrage
//        self.layer.borderWidth = 2.5
//        self.layer.borderColor = UIColor.mtLightYellow.cgColor
//        self.layer.masksToBounds = true
    }
    
    func setupPlaceholderText() {
                let currentPlaceholder = self.placeholder ?? ""
                self.attributedPlaceholder = NSAttributedString(string: currentPlaceholder, attributes: [
                    NSAttributedString.Key.foregroundColor : UIColor.dtTextTribe,
                    NSAttributedString.Key.font : UIFont(name: FontNames.textDriveTribe, size: 16) ?? UIFont(name: "optima", size: 15)!
                ])
        
//        let currentPlaceholder = self.placeholder ?? ""
//        self.attributedPlaceholder = NSAttributedString(string: currentPlaceholder, attributes: [
//            NSAttributedString.Key.foregroundColor : UIColor.mtWhiteText,
//            NSAttributedString.Key.font : UIFont(name: FontNames.textMoneytor, size: 16)!
//        ])
    }
    
    func updateFont(){
      self.font = UIFont(name: FontNames.textDriveTribe, size: 18) ?? UIFont(name: "optima", size: 18)!
    }
}
