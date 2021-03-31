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
        
//
//        let defaults = UserDefaults.standard
//        let appearanceSelection = defaults.integer(forKey: "modeAppearance")
//        if appearanceSelection == 0 {
//            overrideUserInterfaceStyle = .light
//        } else if appearanceSelection == 1 {
//            overrideUserInterfaceStyle = .dark
//        }
        UINavigationBar.appearance().barTintColor = .dtBlueTribe
        UINavigationBar.appearance().tintColor = .dtTextTribe
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.dtBlueTribe]
       // UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: FontNames.textTitleCurlyDriveTribe, size: 25)!]
    }
}

////
class DriveTribeTabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTapBar()
    }
//extension UITabBarController {
    func setupTapBar(){
        UINavigationBar.appearance().barTintColor = .dtBlueTribe
        UINavigationBar.appearance().tintColor = .dtTextTribe
       // UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: FontNames.textTitleCurlyDriveTribe, size: 25)!]
     UITabBar.appearance().barTintColor = .dtBlueTribe
   UITabBar.appearance().tintColor = .dtTextTribe

    }
}



