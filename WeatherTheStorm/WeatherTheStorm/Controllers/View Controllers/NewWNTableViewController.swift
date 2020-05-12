//
//  NewWNTableViewController.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/4/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class NewWNTableViewController: UITableViewController {

    //MARK: - Outlets
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Actions
    
//    @IBAction func closeViewButtonTapped(_ sender: UIBarButtonItem) {
//        segue
//    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let locations = LocationController.shared.sortedLocations else { return 0 }
        return locations.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let locations = LocationController.shared.sortedLocations else { return 0 }
        return locations[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderLocationCell", for: indexPath)
        guard let locations = LocationController.shared.sortedLocations else { return UITableViewCell() }
        let location = locations[indexPath.section][indexPath.row]
        guard let city = location.destination?.locality, let state = location.destination?.administrativeArea, let country = location.destination?.country else { return UITableViewCell() }
        
        cell.textLabel?.text = "\(city), \(state), \(country)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Home"
        case 1:
            return "Work"
        case 2:
            return "Trips"
        case 3:
            return "Favs"
        default:
            return "Other Locations"
        }
    }

   
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddNotificationTiming" {
            guard let indexPath = tableView.indexPathForSelectedRow, let destinationVC = segue.destination as? WNTimingViewController, let locations = LocationController.shared.sortedLocations else { return }
            let location = locations[indexPath.section][indexPath.row]
            
            destinationVC.location = location
        }
    }

}
