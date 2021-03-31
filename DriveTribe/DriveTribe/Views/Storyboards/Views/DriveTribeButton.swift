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
        self.setTitleColor(.dtTextDarkLightTribe, for: .normal)
        self.addCornerRadius()
        self.titleLabel?.font = UIFont(name: FontNames.textDriveTribe, size: 20) ?? UIFont(name: "optima", size: 18)!
    }
    
}

class tableViewDriveTribeButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = .dtAllBlueTribeTribe
        self.setTitleColor(.dtTextDarkLightTribe, for: .normal)
        self.addCornerRadius()
        self.titleLabel?.font = UIFont(name: FontNames.textDriveTribe, size: 15) ?? UIFont(name: "optima", size: 15)!
    }
}

class logInDriveTribeButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = .dtLightTribe
        self.setTitleColor(.dtTextDarkLightTribe, for: .normal)
        self.addCornerRadius()
        self.titleLabel?.font = UIFont(name: FontNames.textDriveTribe, size: 15) ?? UIFont(name: "optima", size: 15)!
    }
}

