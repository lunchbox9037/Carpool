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
       // self.addCornerRadius()
        self.searchTextField.textColor = .white
       // self.backgroundColor = .white
        //self.layer.borderWidth = 1.0
       // self.layer.borderColor = UIColor.dtBlueTribe.cgColor
        self.layer.masksToBounds = true
        self.showsCancelButton = true
        self.showsSearchResultsButton = true
        self.tintColor = .red
        self.barTintColor = .dtBlueTribe
        self.searchTextField.font = UIFont(name: FontNames.textDriveTribe, size: 20) ?? UIFont(name: "optima", size: 18)!
        self.scopeBarButtonTitleTextAttributes(for: .normal)
        self.setScopeBarButtonTitleTextAttributes(attributes, for: .normal)
       
        //self.scopeBarBackgroun
    }
}
