//
//  ReceivedTableViewCell.swift
//  DriveTribe
//
//  Created by Lee McCormick on 3/18/21.
//

import UIKit

// MARK: - Protocol
protocol ReceivedTableViewCellDelagate: AnyObject {
    func acceptFriendButtonTapped(sender: ReceivedTableViewCell)
}

class ReceivedTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    
    // MARK: - Properties
    var friendRequestReceived: User? {
        didSet{
            updateView(friendRequestReceived: friendRequestReceived!)
        }
    }
    
    weak var delegate: ReceivedTableViewCellDelagate?
    
    // MARK: - Actions
    @IBAction func acceptButtonTapped(_ sender: Any) {
        delegate?.acceptFriendButtonTapped(sender: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
    }
    
    func updateView(friendRequestReceived: User) {
        userNameLabel.text = friendRequestReceived.userName
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.backgroundColor = .systemBlue
        acceptButton.tintColor = .white
        acceptButton.layer.cornerRadius = 8
        profileImage.setupRoundCircleViews()
        profileImage.image = UIImage(systemName: "person")

    }
}
