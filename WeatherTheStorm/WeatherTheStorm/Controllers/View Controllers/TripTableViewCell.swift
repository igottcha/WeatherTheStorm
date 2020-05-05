//
//  TripTableViewCell.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 4/29/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    var trip: Trip? {
        didSet {
            guard let trip = trip else { return }
            locationLabel.text = "Location: \(String(describing: trip.location))"
            startDateLabel.text = "Start Date: \(String(describing: trip.startDate))"
            endDateLabel.text = "End Date: \(String(describing: trip.endDate))"
        }
    }
    
    
}
