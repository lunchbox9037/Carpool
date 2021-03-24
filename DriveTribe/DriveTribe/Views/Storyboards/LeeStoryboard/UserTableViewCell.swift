//
//  UserTableViewCell.swift
//  DriveTribe
//
//  Created by Lee McCormick on 3/18/21.
//

import UIKit
// MARK: - Protocol
protocol UserTableViewCellDelagate: AnyObject {
    func requestButtonTapped(sender: UserTableViewCell)
}

class UserTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var requestButton: UIButton!
    
    // MARK: - Properties
    var user: User? {
        didSet{
            updateView(user: user!)
        }
    }
    
    weak var delegate: UserTableViewCellDelagate?
    
    // MARK: - Actions
    @IBAction func requestButtonTapped(_ sender: Any) {
        delegate?.requestButtonTapped(sender: self)
    }
    
    func updateView(user: User) {
        userNameLabel.text = user.userName
        requestButton.setTitle("REQUEST", for: .normal)
        profileImage.setupRoundCircleViews()
        profileImage.image = UIImage(systemName: "person")
    }
}
