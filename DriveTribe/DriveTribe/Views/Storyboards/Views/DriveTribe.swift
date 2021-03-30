//
//  DriveTribe.swift
//  DriveTribe
//
//  Created by Lee on 3/29/21.
//

import Foundation

import UIKit

class DriveTribeLabel: UILabel {
    override  func awakeFromNib() {
        super.awakeFromNib()
        updateFont(fontName: FontNames.textMoneytor)
        self.textColor = .mtTextDarkBrown
    }
    func updateFont(fontName: String) {
        let size = self.font.pointSize
        self.font = UIFont(name: fontName, size: size)
    }
}

class TitleDriveTribeLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textColor = .mtTextDarkBrown
        self.font = UIFont(name: FontNames.textMoneytorGoodLetter, size: 25)
    }
}

class TextDriveTribeLabel: UILabel {
    override  func awakeFromNib() {
        super.awakeFromNib()
        updateFont(fontName: FontNames.textMoneytorMoneyFont)
        self.textColor = .mtWhiteText
    }
    func updateFont(fontName: String) {
        let size = self.font.pointSize
        self.font = UIFont(name: fontName, size: size)
    }
}

