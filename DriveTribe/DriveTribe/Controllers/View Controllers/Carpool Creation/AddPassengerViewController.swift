//
//  AddPassengerViewController.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/17/21.
//

import UIKit
import MapKit
import CoreLocation
import JGProgressHUD

class AddPassengerViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var passengerCollectionView: UICollectionView!
    
    // MARK: - Properties
    var friends: [User] = []
    private var spinner = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        getCurrentUserFriends()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAppearance()
    }
    
    // MARK: - Actions
    @IBAction func saveCarpoolButtonTapped(_ sender: Any) {
        CarpoolController.shared.createCarpool()
        navigationController?.popToRootViewController(animated: true)
    }//end func
    
    // MARK: - Methods
    
    func setupCollectionView() {
        passengerCollectionView.collectionViewLayout = makeLayout()
        passengerCollectionView.backgroundColor = UIColor.systemFill
        
        passengerCollectionView.delegate = self
        passengerCollectionView.dataSource = self
        passengerCollectionView.register(PassengerCollectionViewCell.self, forCellWithReuseIdentifier: "passengerCell")
        passengerCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }//end func
    
    func makeLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            return LayoutBuilder.buildMediaVerticalScrollLayout()
        }
    }//end func
    
    func getCurrentUserFriends() {
        spinner.textLabel.text = "Fetching Friends"
        spinner.show(in: view)
        guard let currentUser = UserController.shared.currentUser else {return print("nouser logged in")}
        UserController.shared.fetchFriendsFor(currentUser: currentUser) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let friends):
                    self?.spinner.dismiss()
                    self?.friends = friends
                    self?.passengerCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }//end func
}//end class

// MARK: - Collectionview DataSource and Delegate extension
extension AddPassengerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = passengerCollectionView.dequeueReusableCell(withReuseIdentifier: "passengerCell", for: indexPath) as? PassengerCollectionViewCell else {return UICollectionViewCell()}
        cell.configure(passenger: friends[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if collectionView.cellForItem(at: indexPath)?.backgroundColor?.accessibilityName != "green" {
            CarpoolController.shared.passengers.append(friends[indexPath.row].uuid)
            collectionView.cellForItem(at: indexPath)?.backgroundColor = .systemGreen
        } else {
            collectionView.cellForItem(at: indexPath)?.backgroundColor = .clear
        }
    }
}//end extension

