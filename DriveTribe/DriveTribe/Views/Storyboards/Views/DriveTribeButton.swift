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
        self.backgroundColor = .dtBlueTribe
        self.setTitleColor(.dtTextTribe, for: .normal)
        self.addCornerRadius()
        self.titleLabel?.font = UIFont(name: FontNames.textDriveTribe, size: 20) ?? UIFont(name: "optima", size: 18)!
    }
    
}

class AnotherDriveTribeButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
//        self.setTitleColor(.mtTextDarkBrown, for: .normal)
//        self.addCornerRadius()
//        self.titleLabel?.font = UIFont(name: FontNames.textMoneytorGoodLetter, size: 25)
    }
}

