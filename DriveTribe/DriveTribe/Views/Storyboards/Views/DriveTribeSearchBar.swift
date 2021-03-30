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
        let titleFont : UIFont = UIFont(name: FontNames.textMoneytorGoodLetter, size: 18)!
               let attributes = [
                NSAttributedString.Key.foregroundColor : UIColor.mtTextLightBrown,
                   NSAttributedString.Key.font : titleFont
               ]
        self.addCornerRadius()
        self.searchTextField.textColor = .mtTextLightBrown
        self.backgroundColor = .mtLightYellow
        self.layer.borderWidth = 2.5
        self.layer.borderColor = UIColor.mtLightYellow.cgColor
        self.layer.masksToBounds = true
        self.showsCancelButton = true
        self.showsSearchResultsButton = true
        self.tintColor = .mtTextDarkBrown
        self.searchTextField.font = UIFont(name: FontNames.textMoneytorGoodLetter, size: 20)!
        self.scopeBarButtonTitleTextAttributes(for: .highlighted)
        self.setScopeBarButtonTitleTextAttributes(attributes, for: .normal)
    }
}
