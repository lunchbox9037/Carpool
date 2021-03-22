//
//  CarpoolListViewController.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/16/21.
//

import UIKit
import SafariServices

class CarpoolListViewController: UIViewController, SFSafariViewControllerDelegate {
    // MARK: - Outlets
    @IBOutlet weak var carpoolGroupLabel: UILabel!
    @IBOutlet weak var carpoolTableVIew: UITableView!
    @IBOutlet weak var workPlaySegment: UISegmentedControl!
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        carpoolTableVIew.dataSource = self
        carpoolTableVIew.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        carpoolTableVIew.reloadData()
    }

    // MARK: - Actions
    //dont need this?
    @IBAction func addCarpoolButtonTapped(_ sender: Any) {
        //present carpoolDestinationViewController
    }
    @IBAction func workPlaySegmentChanged(_ sender: Any) {
        if workPlaySegment.selectedSegmentIndex == 0 {
            carpoolGroupLabel.text = "Work Tribes"
            overrideUserInterfaceStyle = .light
        } else {
            carpoolGroupLabel.text = "Play Tribes"
            overrideUserInterfaceStyle = .dark
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        self.hidesBottomBarWhenPushed = true
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
        cell.detailTextLabel?.text = "Destination: \(carpool.destination.placemark.name ?? "parts unknown")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let carpuul = CarpoolController.shared.carpools[indexPath.row]
        let destination = carpuul.destination.placemark.coordinate
        
        let originCoordinates: String = "37.8225233451249, -122.47777076253998"
    
        var destinationCoordinates: String = ""
        destinationCoordinates.append(String(destination.latitude) + ",")
        destinationCoordinates.append(String(destination.longitude))
        print(destinationCoordinates)
        
        var stopsCoordinates: String = ""
       // var index = 0
        for location in carpuul.stops {
            /*
            stopsCoordinates.append(String(location[index]) + ",")
            index += 1
            stopsCoordinates.append(String(location[index]) + "|")
            index += 1
            */
            stopsCoordinates.append(String(location.latitude) + ",")
            stopsCoordinates.append(String(location.longitude) + "|")
        }
        //drop the comma in muliple stops
        if stopsCoordinates.last == "|" {
            stopsCoordinates = String(stopsCoordinates.dropLast(1))
        }
        print(stopsCoordinates)
        
        //"https://www.google.com/maps/dir/?api=1
//        &waypoints=Golden+Gate+Bridge%7CAlcatraz
//        &destination=Oracle+Park
//        &travelmode=driving
//        &dir_action=navigate"
        guard let baseURL = URL(string: "https://www.google.com/maps/dir/") else {return}
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: "api", value: "1")
        let originQuery = URLQueryItem(name: "origin", value: originCoordinates)
        let stopsQuery = URLQueryItem(name: "waypoints", value: stopsCoordinates)
        let destinationQuery = URLQueryItem(name: "destination", value: destinationCoordinates)
        let travelModeQuery = URLQueryItem(name: "travelmode", value: "driving")
        let navigateQuery = URLQueryItem(name: "dir_action", value: "navigate")
        
        components?.queryItems = [apiQuery, originQuery, stopsQuery, destinationQuery, travelModeQuery, navigateQuery]
        guard let finalURL = components?.url?.absoluteString else {return}
        print(finalURL)
        
        if let url = URL(string: finalURL ) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            present(vc, animated: true)
        } else {
            print("invalid url")
        }
    }
    
    
}//end extension
