//
//  CarpoolListViewController.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/16/21.
//

import UIKit

class CarpoolListViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var carpoolGroupLabel: UILabel!
    @IBOutlet weak var carpoolTableVIew: UITableView!
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        carpoolTableVIew.dataSource = self
        carpoolTableVIew.delegate = self
    }

    // MARK: - Actions
    @IBAction func addCarpoolButtonTapped(_ sender: Any) {
        //present carpoolDestinationViewController
       
    }
    
}//end class

extension CarpoolListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CarpoolController.shared.carpools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = carpoolTableVIew.dequeueReusableCell(withIdentifier: "carpoolCell", for: indexPath)
        let carpool = CarpoolController.shared.carpools[indexPath.row]
        cell.textLabel?.text = carpool.title
        cell.detailTextLabel?.text = carpool.destination.title
        
        return cell
    }
    
    
}//end extension
