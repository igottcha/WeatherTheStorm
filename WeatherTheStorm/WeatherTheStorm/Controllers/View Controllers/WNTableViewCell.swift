//
//  WeatherNotificationTableViewCell.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/7/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

protocol WNTableViewCellDelegate {
    func toggleCellButtonToggled(_ sender: WNTableViewCell)
}

class WNTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var isNotificationActiveSwitch: UISwitch!
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var frequencyAndTimeLabel: UILabel!
    
    //MARK: - Properties
    
    var delegate: WNTableViewCellDelegate?
    
    //MARK: - Actions
    
    @IBAction func isActiveSwitchToggled(_ sender: UISwitch) {
        delegate?.toggleCellButtonToggled(self)
    }
    
    
    
    
}
