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
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.cornerRadius = 8
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 32
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var passengerNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Some subtitle"
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
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
        
        let aspectRatio = NSLayoutConstraint(
            item: profileImageView,
            attribute: .height,
            relatedBy: .equal,
            toItem: profileImageView,
            attribute: .width,
            multiplier: 1,
            constant: 0)
        
        NSLayoutConstraint.activate([
            self.profileImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            self.profileImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            aspectRatio
        ])
        
        NSLayoutConstraint.activate([
            self.passengerNameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            self.passengerNameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            self.passengerNameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }
    
    func configure(passenger: User) {
        
        profileImageView.image = UIImage(systemName: "person.circle")

        StorageController.shared.getImage(user: passenger) { [weak self] (results) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch results {
                case .success(let image):
                    self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.height / 2
                    self.profileImageView.image = image
                case .failure(let error):
                    print("\n==== ERROR IN \(#function) : \(error.localizedDescription) : \(error) ====\n")
                }
            }
        }
        self.passengerNameLabel.text = passenger.firstName
    }
}//end class
