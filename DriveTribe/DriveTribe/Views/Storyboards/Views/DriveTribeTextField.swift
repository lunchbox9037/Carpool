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
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.dtLightTribe.cgColor
                self.layer.masksToBounds = true
    }
    
    func setupPlaceholderText() {
                let currentPlaceholder = self.placeholder ?? ""
                self.attributedPlaceholder = NSAttributedString(string: currentPlaceholder, attributes: [
                    NSAttributedString.Key.foregroundColor : UIColor.dtBlueTribe,
                    NSAttributedString.Key.font : UIFont(name: FontNames.textDriveTribe, size: 16) ?? UIFont(name: "optima", size: 15)!
                ])
    }
    
    func updateFont(){
      self.font = UIFont(name: FontNames.textDriveTribe, size: 20) ?? UIFont(name: "optima", size: 18)!
    }
}
