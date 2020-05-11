//
//  WeatherNotificationTimingViewController.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/8/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class WeatherNotificationTimingViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var addressLabel: UILabel!
    
    //MARK: - Properties
    
    var location: Location?
    
    //MARK: -  Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let city = location?.destination?.locality, let address = location?.destination?.thoroughfare, let state = location?.destination?.administrativeArea, let country = location?.destination?.country else { return }
        addressLabel.text = "\(address), \(city), \(state), \(country)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
