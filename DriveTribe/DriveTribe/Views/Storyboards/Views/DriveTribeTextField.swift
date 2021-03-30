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
        self.textColor = .mtTextDarkBrown
        self.backgroundColor = .mtDarkOrage
        self.layer.borderWidth = 2.5
        self.layer.borderColor = UIColor.mtLightYellow.cgColor
        self.layer.masksToBounds = true
    }
    
    func setupPlaceholderText() {
        let currentPlaceholder = self.placeholder ?? ""
        self.attributedPlaceholder = NSAttributedString(string: currentPlaceholder, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.mtWhiteText,
            NSAttributedString.Key.font : UIFont(name: FontNames.textMoneytor, size: 16)!
        ])
    }
    
    func updateFont(){
        self.font = UIFont(name: FontNames.textTitleBoldMoneytor, size: 20)
    }
}
