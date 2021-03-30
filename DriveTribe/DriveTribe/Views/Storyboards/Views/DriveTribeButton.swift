//
//  DriveTribeButton.swift
//  DriveTribe
//
//  Created by Lee on 3/29/21.
//

import UIKit

class DriveTribeButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = .mtBgBrownHeader
        self.setTitleColor(.mtWhiteText, for: .normal)
        self.addCornerRadius()
        self.titleLabel?.font = UIFont(name: FontNames.textTitleBoldMoneytor, size: 22)
    }
}

class AnotherDriveTribeButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.setTitleColor(.mtTextDarkBrown, for: .normal)
        self.addCornerRadius()
        self.titleLabel?.font = UIFont(name: FontNames.textMoneytorGoodLetter, size: 25)
    }
}

