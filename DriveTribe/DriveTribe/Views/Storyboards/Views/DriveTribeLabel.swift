//
//  DriveTribeLabel.swift
//  DriveTribe
//
//  Created by Lee on 3/29/21.
//

import Foundation

import UIKit

class TextDriveTribeLabel: UILabel {
    override  func awakeFromNib() {
        super.awakeFromNib()
        updateFont(fontName: FontNames.textDriveTribe)
       // self.textColor = .dtWhiteBlackTribe
    }
    func updateFont(fontName: String) {
        let size = self.font.pointSize
        self.font = UIFont(name: fontName, size: size)
    }
}

class TitleDriveTribeLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.textColor = .dtTextTribe
        self.font = UIFont(name: FontNames.textTitleBoldDriveTribe, size: 25)
    }
}

class TitleDriveTribeCurlyLabel: UILabel {
    override  func awakeFromNib() {
        super.awakeFromNib()
        updateFont(fontName: FontNames.textTitleCurlyDriveTribe)
        self.textColor = .dtWhiteBlackTribe
    }
    func updateFont(fontName: String) {
        let size = self.font.pointSize
        self.font = UIFont(name: fontName, size: size)
    }
}

