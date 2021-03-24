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

class FriendTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var unfriendButton: UIButton!
    
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
    
    // MARK: - Helper Fuctions
    func updateView(friend: User) {
        userNameLabel.text = friend.userName
        unfriendButton.setTitle("UNFRIEND", for: .normal)
        profileImage.setupRoundCircleViews()
        profileImage.image = UIImage(systemName: "person")
    }
}

