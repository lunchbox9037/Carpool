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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if workPlaySegment.selectedSegmentIndex == 0 {
            CarpoolController.shared.type = "work"
        } else {
            CarpoolController.shared.type = "play"
        }
        guard let text = titleTextField.text, !text.isEmpty else {return}
        CarpoolController.shared.title = text
    }
    
}//end class

//extension CarpoolSettingsViewController: UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//    }
//}//end extension
