//
//  PassengerCollectionViewCell.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/17/21.
//

import UIKit

public class PassengerCollectionViewCell: UICollectionViewCell {
    // MARK: - Views
    var container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemFill
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.cornerRadius = 8
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 32
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var profileImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.backgroundColor = .systemRed
        imageView.layer.masksToBounds = false
//        imageView.clipsToBounds = true
        return imageView
    }()
    
    var passengerNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Some subtitle"
        label.font = UIFont.preferredFont(forTextStyle: .footnote).withSize(12)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.container)
        self.container.addSubview(self.profileImageView)
        self.container.addSubview(self.passengerNameLabel)

        NSLayoutConstraint.activate([
            self.container.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.container.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.container.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.container.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.profileImageView.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 0),
            self.profileImageView.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 0),
            self.profileImageView.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: 0),
            self.profileImageView.heightAnchor.constraint(equalToConstant: 80)
//            self.profileImageView.bottomAnchor.constraint(equalTo: self.container.bottomAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            self.passengerNameLabel.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 8),
            self.passengerNameLabel.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 0),
            self.passengerNameLabel.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: 0),
            self.passengerNameLabel.bottomAnchor.constraint(equalTo: self.container.bottomAnchor, constant: 8),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(passenger: User) {
        self.profileImageView.image = UIImage(systemName: "person")
        self.passengerNameLabel.text = passenger.firstName
    }
}//end class
