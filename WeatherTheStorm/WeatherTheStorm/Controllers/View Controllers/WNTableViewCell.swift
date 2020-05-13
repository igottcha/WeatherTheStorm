//
//  WeatherNotificationTableViewCell.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/7/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class WNTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var frequencyAndTimeLabel: UILabel!
    
    //MARK: - Actions
    
    @IBAction func isActiveSwitch(_ sender: UISwitch) {
    }
    
    
    
}
