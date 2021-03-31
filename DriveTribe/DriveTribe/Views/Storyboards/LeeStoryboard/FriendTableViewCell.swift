//
//  FriendTableViewCell.swift
//  DriveTribe
//
//  Created by Lee McCormick on 3/18/21.
//

import UIKit

// MARK: - Protocol
protocol FriendTableViewCellCellDelagate: AnyObject {
    func unfriendButtonTapped(sender: FriendTableViewCell)
    func blockFriendButtonTapped(sender: FriendTableViewCell)
}

class FriendTableViewCell: DriveTribeTableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var unfriendButton: UIButton!
    @IBOutlet weak var blockButton: UIButton!
    
    var friend: User? {
        didSet {
            updateView(friend: friend!)
        }
    }
    
    weak var delegate: FriendTableViewCellCellDelagate?
    
    // MARK: - Actions
    @IBAction func unfriendButtonTapped(_ sender: Any) {
        delegate?.unfriendButtonTapped(sender: self)
    }
    
    
    @IBAction func blockedButtonTapped(_ sender: Any) {
        delegate?.blockFriendButtonTapped(sender: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
    }
    
    // MARK: - Helper Fuctions
    func updateView(friend: User) {
        userNameLabel.text = friend.userName
        unfriendButton.setTitle("Unfriend", for: .normal)
        blockButton.tintColor = .dtWhiteBlackTribe
        blockButton.setTitle("🚫", for: .normal)
        blockButton.addCornerRadius()
        profileImage.setupRoundCircleViews()
        profileImage.image = UIImage(systemName: "person")
    }
}


