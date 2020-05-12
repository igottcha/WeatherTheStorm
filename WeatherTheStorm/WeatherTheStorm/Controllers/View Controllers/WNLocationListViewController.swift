//
//  WNLocationListViewController.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/12/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class WNLocationListViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var addNotificatonTitleBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var closeViewBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var locationListTableView: UITableView!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationListTableView.delegate = self
        locationListTableView.dataSource = self

    }
    
    //MARK: - Actions
    
    @IBAction func closeViewButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddNotificationTiming" {
            guard let indexPath = locationListTableView.indexPathForSelectedRow, let destinationVC = segue.destination as? WNTimingViewController, let locations = LocationController.shared.sortedLocations else { return }
            let location = locations[indexPath.section][indexPath.row]
            
            destinationVC.location = location
        }
    }

}

extension WNLocationListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let locations = LocationController.shared.sortedLocations else { return 0 }
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let locations = LocationController.shared.sortedLocations else { return 0 }
        return locations[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderLocationCell", for: indexPath)
        guard let locations = LocationController.shared.sortedLocations else { return UITableViewCell() }
        let location = locations[indexPath.section][indexPath.row]
        guard let city = location.destination?.locality, let state = location.destination?.administrativeArea, let country = location.destination?.country else { return UITableViewCell() }
        
        cell.textLabel?.text = "\(city), \(state), \(country)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
}
