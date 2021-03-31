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
        UINavigationBar.appearance().barTintColor = .dtBlueTribe
        UINavigationBar.appearance().tintColor = .dtTextTribe
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.dtBlueTribe]
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: FontNames.textTitleCurlyDriveTribe, size: 25)  ?? UIFont(name: "optima", size: 25)!]
    }
}

////
class DriveTribeTabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTapBar()
    }
    
    func setupTapBar(){
        UITabBar.appearance().unselectedItemTintColor = .dtLightTribe
        UITabBar.appearance().barTintColor = .dtBlueTribe
        UITabBar.appearance().tintColor = .dtTextTribe
    }
}



