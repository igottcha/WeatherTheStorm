//
//  WNListTableViewController.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/7/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class WNListTableViewController: UITableViewController {

    
    //MARK: - Outlets
    
    @IBOutlet var previewView: UIView!
    @IBOutlet weak var previewLabel: UILabel!
    
    //MARK: - Properties
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = previewView
        //DataManager.shared.firstVC = self
        updateEmptyState()
        setGradientBackground()
        WeatherNotificationController.shared.fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "boxCell", for: indexPath) as? WNTableViewCell else { return UITableViewCell() }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        
        let weatherNotification = WeatherNotificationController.shared.fetchedResultsController.object(at: indexPath)
        let frequency: [String]
        
        if let data = WeatherNotificationController.shared.fetchedResultsController.object(at: indexPath).frequency {
            frequency = try! JSONDecoder().decode([String].self, from: data)
        } else {
            frequency = ["TBD"]
        }
        
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
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let weatherNotification = WeatherNotificationController.shared.fetchedResultsController.object(at: indexPath)
            WeatherNotificationController.shared.deleteWeatherNotificaiton(weatherNotification: weatherNotification)
        }    
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
extension WNListTableViewController: NSFetchedResultsControllerDelegate {

func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
}

func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
}

func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
    switch type {
    case .delete:
        guard let indexPath = indexPath else { break }
        tableView.deleteRows(at: [indexPath], with: .fade)
    case .insert:
        guard let newIndexPath = newIndexPath else { break }
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    case .move:
        guard let fromIndexPath = indexPath, let newIndexPath = newIndexPath else { break }
        tableView.moveRow(at: fromIndexPath, to: newIndexPath)
    case .update:
        guard let indexPath = indexPath else { break }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    @unknown default:
        fatalError()
    }
}

func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
    case .delete:
        tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
    case .insert:
        tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
    case .move:
        break
    case .update:
        break
    @unknown default:
        fatalError()
    }
}

}
