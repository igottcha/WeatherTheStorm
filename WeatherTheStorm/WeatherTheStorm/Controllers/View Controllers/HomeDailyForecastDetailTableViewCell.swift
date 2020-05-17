//
//  HomeDailyForecastDetailTableViewCell.swift
//  WeatherTheStorm
//
//  Created by Sean Jones on 5/16/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class HomeDailyForecastDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var HiLabel: UILabel!
    @IBOutlet weak var LoLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
