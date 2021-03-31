//
//  CarpoolSettingsViewController.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/18/21.
//

import UIKit

class CarpoolSettingsViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var workPlayModeSegment: UISegmentedControl!
    @IBOutlet weak var carpoolMeetUpSegement: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAppearance()
    }
    
    func getSettings() {
        if workPlayModeSegment.selectedSegmentIndex == 0 {
            CarpoolController.shared.mode = "work"
        } else {
            CarpoolController.shared.mode = "play"
        }

        if carpoolMeetUpSegement.selectedSegmentIndex == 0 {
            CarpoolController.shared.type = "carpool"
        } else {
            CarpoolController.shared.type = "meetup"
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let text = titleTextField.text, !text.isEmpty else {
            presentAlertToUser(titleAlert: "Whoops", messageAlert: "Please enter a title!")
            return false
        }
        
        CarpoolController.shared.title = text
        getSettings()
        
        return true
    }
    
}//end class
