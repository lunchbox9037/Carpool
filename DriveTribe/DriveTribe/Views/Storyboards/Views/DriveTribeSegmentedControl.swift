//
//  DriveTribeSegmentedControl.swift
//  DriveTribe
//
//  Created by Lee on 3/29/21.
//


import UIKit

class DriveTribeSegmentedControl: UISegmentedControl {
    override  func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func setupView() {
        
        let titleFont : UIFont = UIFont(name: FontNames.textDriveTribe, size: 18) ?? UIFont(name: "optima", size: 15)!
               let attributes = [
                NSAttributedString.Key.foregroundColor : UIColor.dtTextTribe,
                   NSAttributedString.Key.font : titleFont
               ]
        self.backgroundColor = .dtBlueTribe
        self.selectedSegmentTintColor = .dtLightTribe
        self.setTitleTextAttributes(attributes, for: .normal)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.dtLightTribe.cgColor
        self.setTitleTextAttributes([.foregroundColor : UIColor.dtTextDarkLightTribe], for: .selected)
               self.addCornerRadius()
    }
}
