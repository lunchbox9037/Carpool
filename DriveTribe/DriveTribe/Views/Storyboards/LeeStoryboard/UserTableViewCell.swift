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

class UserTableViewCell: DriveTribeTableViewCell {
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
    }
    
    func updateView(user: User) {
        userNameLabel.text = user.userName
        requestButton.setTitle("Request", for: .normal)
//        requestButton.backgroundColor = .systemBlue
//        requestButton.tintColor = .white
//        requestButton.layer.cornerRadius = 8
        profileImage.setupRoundCircleViews()
        profileImage.image = UIImage(systemName: "person")
    }
}
