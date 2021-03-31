//
//  DriveTribeTableView.swift
//  DriveTribe
//
//  Created by Lee on 3/30/21.
//

import UIKit

class DriveTribeTableViewController: UITableView {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }
    
  
    func setupTableView(){
        self.backgroundColor = UIColor.dtBackground
        self.tintColor = UIColor.dtTextTribe
    }
}

class DriveTribeTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }
    
    func setupTableView(){
        self.backgroundColor = UIColor.dtBackground
        self.tintColor = UIColor.dtTextTribe
    }
}

