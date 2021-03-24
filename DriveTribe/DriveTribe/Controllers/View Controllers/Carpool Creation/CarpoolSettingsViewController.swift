//
//  CarpoolSettingsViewController.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/18/21.
//

import UIKit

class CarpoolSettingsViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var workPlaySegment: UISegmentedControl!
    @IBOutlet weak var carpoolMeetUpSegement: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAppearance()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if workPlaySegment.selectedSegmentIndex == 0 {
            CarpoolController.shared.mode = "work"
        } else {
            CarpoolController.shared.mode = "play"
        }
        
        if carpoolMeetUpSegement.selectedSegmentIndex == 0 {
            CarpoolController.shared.type = "carpool"
        } else {
            CarpoolController.shared.type = "meetup"
        }
        
        guard let text = titleTextField.text, !text.isEmpty else {return}
        CarpoolController.shared.title = text
    }
    
}//end class
