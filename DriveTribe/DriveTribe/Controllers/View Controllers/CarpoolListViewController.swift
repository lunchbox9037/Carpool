//
//  CarpoolListViewController.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/16/21.
//

import UIKit
import MapKit
import Firebase

class CarpoolListViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var carpoolGroupLabel: UILabel!
    @IBOutlet weak var carpoolTableView: UITableView!
    @IBOutlet weak var workPlaySegment: UISegmentedControl!
    
    // MARK: - Properties
    var dataSource: [Carpool] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        carpoolTableView.dataSource = self
        carpoolTableView.delegate = self
        overrideUserInterfaceStyle = .light
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        setAppearance()
        fetchCarpoolsByCurrentUser()
    }

    // MARK: - Actions
    @IBAction func workPlaySegmentChanged(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        if workPlaySegment.selectedSegmentIndex == 0 {
            carpoolGroupLabel.text = "Work Tribes"
            overrideUserInterfaceStyle = .light
            defaults.setValue(0, forKey: "modeAppearance")
            dataSource = CarpoolController.shared.work
        } else {
            carpoolGroupLabel.text = "Play Tribes"
            overrideUserInterfaceStyle = .dark
            defaults.setValue(1, forKey: "modeAppearance")
            dataSource = CarpoolController.shared.play
        }
        carpoolTableView.reloadData()
    }
    
    // MARK: - Methods
    func fetchCarpoolsByCurrentUser() {
        CarpoolController.shared.fetchGroupsForCurrentUser { [weak self] (result) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    CarpoolController.shared.sortCarpoolsByWorkPlay()
                    if self?.workPlaySegment.selectedSegmentIndex == 0 {
                        self?.dataSource = CarpoolController.shared.work
                    } else if self?.workPlaySegment.selectedSegmentIndex == 1 {
                        self?.dataSource = CarpoolController.shared.play
                    }
                    self?.carpoolTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }//end func
}//end class

extension CarpoolListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = carpoolTableView.dequeueReusableCell(withIdentifier: "carpoolCell", for: indexPath)
        let carpool = dataSource[indexPath.row]
        cell.textLabel?.text = carpool.title
        cell.detailTextLabel?.text = "Destination: \(carpool.destinationName)"
        
        if carpool.type == "carpool" {
            cell.imageView?.image = UIImage(systemName: "car")
        } else {
            cell.imageView?.image = UIImage(systemName: "car.2")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let detailVC = UIStoryboard(name: "Carpool", bundle: nil)  .instantiateViewController(withIdentifier: "tribeDetail") as? TribeDetailViewController else {return}
        detailVC.tribe = dataSource[indexPath.row]
        
        detailVC.modalPresentationStyle = .automatic
        present(detailVC, animated: true, completion: nil)
    }
}//end extension
