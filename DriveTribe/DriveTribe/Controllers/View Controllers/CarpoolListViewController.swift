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
        UserDefaults.standard.setValue(0, forKey: "modeAppearance")
        addCarpoolListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        setAppearance()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }

    // MARK: - Actions
    @IBAction func workPlaySegmentChanged(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        if workPlaySegment.selectedSegmentIndex == 0 {
            overrideUserInterfaceStyle = .light
            defaults.setValue(0, forKey: "modeAppearance")
            dataSource = CarpoolController.shared.work
        } else {
            overrideUserInterfaceStyle = .dark
            defaults.setValue(1, forKey: "modeAppearance")
            dataSource = CarpoolController.shared.play
        }
        carpoolTableView.reloadData()
    }
    
    // MARK: - Methods
    func addCarpoolListener() {
        CarpoolController.shared.fetchGroupsForCurrentUser { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                        print("loadedGroup")
                        CarpoolController.shared.sortCarpoolsByWorkPlay()
                        if self?.workPlaySegment.selectedSegmentIndex == 0 {
                            self?.dataSource = CarpoolController.shared.work
                        } else if self?.workPlaySegment.selectedSegmentIndex == 1 {
                            self?.dataSource = CarpoolController.shared.play
                        }

                case .failure(let error):
                    print("failed")
                    CarpoolController.shared.sortCarpoolsByWorkPlay()
                    if self?.workPlaySegment.selectedSegmentIndex == 0 {
                        self?.dataSource = CarpoolController.shared.work
                    } else if self?.workPlaySegment.selectedSegmentIndex == 1 {
                        self?.dataSource = CarpoolController.shared.play
                    }
                    print(error.localizedDescription)
                }
                self?.carpoolTableView.reloadData()

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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let carpoolToDelete = dataSource[indexPath.row]
            //call delete functions
            guard let indexToDelete = dataSource.firstIndex(of: carpoolToDelete) else {return}
            dataSource.remove(at: indexToDelete)
            CarpoolController.shared.delete(carpool: carpoolToDelete) { (_) in}
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCarpoolChat" {
            guard let indexPath =  carpoolTableView.indexPathForSelectedRow,
                  let destination = segue.destination as? ChatViewController else {return}
            let carpoolToSend = dataSource[indexPath.row]
            destination.tribe = carpoolToSend
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        guard let detailVC = UIStoryboard(name: "Carpool", bundle: nil)  .instantiateViewController(withIdentifier: "tribeDetail") as? ChatViewController else {return}
//
//        let nav = UINavigationController(rootViewController: detailVC)
//        
//        detailVC.tribe = dataSource[indexPath.row]
//        
//        
//        nav.modalPresentationStyle = .fullScreen
//        present(nav, animated: true, completion: nil)
//    }
}//end extension
