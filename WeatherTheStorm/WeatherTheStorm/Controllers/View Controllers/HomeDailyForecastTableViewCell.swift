//
//  HomeDailyForecastTableViewCell.swift
//  WeatherTheStorm
//
//  Created by Sean Jones on 5/14/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class HomeDailyForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var HiLabel: UILabel!
    @IBOutlet weak var loLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
