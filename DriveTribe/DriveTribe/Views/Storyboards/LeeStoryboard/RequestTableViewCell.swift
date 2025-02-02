//
//  RequestTableViewCell.swift
//  DriveTribe
//
//  Created by Lee McCormick on 3/18/21.
//

import UIKit

// MARK: - Protocol
    protocol RequestTableViewCellDelagate: AnyObject {
    func cancelFriendRequestButtonTapped(sender: RequestTableViewCell)
    }

class RequestTableViewCell: DriveTribeTableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - Properties
    var friendRequestSent: User? {
        didSet{
            updateView(friendRequestSent: friendRequestSent!)
        }
    }
    
    weak var delegate: RequestTableViewCellDelagate?
    
    // MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        delegate?.cancelFriendRequestButtonTapped(sender: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
    }
    
    func updateView(friendRequestSent: User) {
        userNameLabel.text = friendRequestSent.userName
        cancelButton.setTitle("Cancel", for: .normal)
        profileImage.setupRoundCircleViews()
        profileImage.image = UIImage(systemName: "person")
        userNameLabel.font = UIFont(name: FontNames.textDriveTribe, size: 20)
        userNameLabel.textColor = .dtTextDarkLightTribe
    }
}
