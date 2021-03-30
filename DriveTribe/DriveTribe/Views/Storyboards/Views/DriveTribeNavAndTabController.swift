//
//  DriveTribeNavANDTabController.swift
//  DriveTribe
//
//  Created by Lee on 3/29/21.
//

import UIKit

class DriveTribeNavigationController: UINavigationController {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupNavigationBar()
    }
    
    func setupNavigationBar(){
        UINavigationBar.appearance().barTintColor = .mtBgBrownHeader
        UINavigationBar.appearance().tintColor = .mtTextDarkBrown
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mtTextDarkBrown]
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: FontNames.textMoneytorMoneyFont, size: 25)!]
    }
}

class DriveTribeTabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTapBar()
    }
    
    func setupTapBar(){
        UINavigationBar.appearance().barTintColor = .mtBgBrownHeader
        UINavigationBar.appearance().tintColor = .mtTextDarkBrown
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: FontNames.textMoneytorGoodLetter, size: 25)!]
     UITabBar.appearance().barTintColor = .mtBgBrownHeader
   UITabBar.appearance().tintColor = .mtTextDarkBrown

    }
}
