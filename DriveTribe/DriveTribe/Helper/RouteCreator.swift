//
//  RouteCreator.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/22/21.
//

import UIKit
import SafariServices

extension UIViewController: SFSafariViewControllerDelegate {

    //create function for meetup route >>>>>
    func createMeetupRoute(from carpool: Carpool, with driver: User) {
        //create route without passengers
        var originCoordinates: String = ""
        originCoordinates.append(String(driver.lastCurrentLocation[0]) + ",")
        originCoordinates.append(String(driver.lastCurrentLocation[1]))
        
        let destination = carpool.destination
        var destinationCoordinates: String = ""
        destinationCoordinates.append(String(destination[0]) + ",")
        destinationCoordinates.append(String(destination[1]))
        print(destinationCoordinates)
        
        openGoogleMapsWith(originCoordinates: originCoordinates, stopsCoordinates: nil, destinationCoordinates: destinationCoordinates)
    }
    
    func createCarpoolRoute(from carpool: Carpool, with driver: User, and passengers: [User]) {
        var originCoordinates: String = ""
        originCoordinates.append(String(driver.lastCurrentLocation[0]) + ",")
        originCoordinates.append(String(driver.lastCurrentLocation[1]))

        let destination = carpool.destination
        var destinationCoordinates: String = ""
        destinationCoordinates.append(String(destination[0]) + ",")
        destinationCoordinates.append(String(destination[1]))
        print(destinationCoordinates)
        
        var stopsCoordinates: String = ""
        for passenger in passengers {
            stopsCoordinates.append(String(passenger.lastCurrentLocation[0]) + ",")
            stopsCoordinates.append(String(passenger.lastCurrentLocation[1]) + "|")
        }
        //drop the comma in multiple stops
        if stopsCoordinates.last == "|" {
            stopsCoordinates = String(stopsCoordinates.dropLast(1))
        }
        print(stopsCoordinates)
        openGoogleMapsWith(originCoordinates: originCoordinates, stopsCoordinates: stopsCoordinates, destinationCoordinates: destinationCoordinates)
    }
    
    func openGoogleMapsWith(originCoordinates: String, stopsCoordinates: String?, destinationCoordinates: String) {
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
        
        components?.queryItems = [apiQuery, originQuery, destinationQuery, travelModeQuery, navigateQuery]
        
        if stopsCoordinates != nil {
            components?.queryItems?.append(stopsQuery)
        }
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
}
