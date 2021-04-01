//
//  DriveTribeSearchBar.swift
//  DriveTribe
//
//  Created by Lee on 3/29/21.
//

import UIKit

class DriveTribeSearchBar: UISearchBar {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        let titleFont: UIFont = UIFont(name: FontNames.textDriveTribe, size: 18) ?? UIFont(name: "optima", size: 15)!
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.dtTextTribe,
            NSAttributedString.Key.font : titleFont
        ]
        self.searchTextField.textColor = .white
        self.layer.masksToBounds = true
        self.showsCancelButton = true
        self.showsSearchResultsButton = false
        self.autocapitalizationType = .none
        self.barTintColor = .dtBlueTribe
        self.searchTextField.font = UIFont(name: FontNames.textDriveTribe, size: 18) ?? UIFont(name: "optima", size: 18)!
        self.scopeBarButtonTitleTextAttributes(for: .normal)
        self.setScopeBarButtonTitleTextAttributes(attributes, for: .normal)
        if #available(iOS 13.0, *) {
            self.searchBarStyle = .default
            self.searchTextField.backgroundColor = UIColor.dtBlueTribeLight.withAlphaComponent(0.5)
        }
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
        UISegmentedControl.appearance().backgroundColor = .dtBlueTribe
        UISegmentedControl.appearance().selectedSegmentTintColor = .dtLightTribe
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .normal)
        UISegmentedControl.appearance().layer.borderWidth = 1
        UISegmentedControl.appearance().layer.borderColor = UIColor.dtLightTribe.cgColor
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.dtTextDarkLightTribe], for: .selected)
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
}
