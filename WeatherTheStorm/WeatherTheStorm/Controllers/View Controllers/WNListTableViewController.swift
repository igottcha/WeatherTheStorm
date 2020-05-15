//
//  WNListTableViewController.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/7/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit
import CoreLocation

class WNListTableViewController: UITableViewController {

    
    //MARK: - Outlets
    
    @IBOutlet var previewView: UIView!
    @IBOutlet weak var previewLabel: UILabel!
    
    //MARK: - Properties
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateEmptyState()
        tableView.backgroundView = previewView
        setGradientBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateEmptyState()
        tableView.reloadData()
    }

    //MARK: - Methods
    
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(named: "alertTabBackgroundTopColor")?.cgColor ?? UIColor.yellow.cgColor, UIColor(named: "alertTabBackgroundBottomColor")?.cgColor ?? UIColor.white.cgColor]
        previewView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func updateEmptyState() {
        previewLabel.isHidden = (WeatherNotificationController.shared.fetchedResultsController.fetchedObjects?.count != 0)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeatherNotificationController.shared.fetchedResultsController.fetchedObjects?.count ?? 0
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "boxCell", for: indexPath) as? WNTableViewCell, let data = WeatherNotificationController.shared.fetchedResultsController.object(at: indexPath).frequency else { return UITableViewCell() }
        
        let weatherNotification = WeatherNotificationController.shared.fetchedResultsController.object(at: indexPath)
        
        let frequency: [String] = try! JSONDecoder().decode([String].self, from: data) ?? ["TBD"]
        let time = weatherNotification.time?.hour() ?? Date().hour()
        
        cell.boxView.layer.cornerRadius = 7
        cell.isNotificationActiveSwitch.isOn = weatherNotification.isActive
        cell.nameLabel.text = weatherNotification.name
        cell.addressLabel.text = "\(weatherNotification.location?.city ?? ""), \(weatherNotification.location?.state ?? ""), \(weatherNotification.location?.country ?? "")"
        cell.frequencyAndTimeLabel.text = "Every \(frequency.compactMap({$0}).joined(separator: ", ")), at \(time)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as? WNTableViewCell
        cell?.backgroundColor = .clear
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
