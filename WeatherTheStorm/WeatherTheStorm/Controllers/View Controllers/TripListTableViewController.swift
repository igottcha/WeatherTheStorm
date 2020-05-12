//
//  TripListTableViewController.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 5/12/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit
import CoreData

class TripListTableViewController: UITableViewController {
    
    //MARK: - Properties
    var trips: [Trip] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        tableView.rowHeight = 200
        TripController.shared.fetchedResultsController.delegate = self
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return TripController.shared.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath) as? TripTableViewCell else { return UITableViewCell() }
        let trip = TripController.shared.fetchedResultsController.object(at: indexPath)
        
        guard let city = trip.location?.destination?.locality,
            let state = trip.location?.destination?.administrativeArea,
            let country = trip.location?.destination?.country,
            let startDate = trip.startDate,
            let endDate = trip.endDate else { return UITableViewCell() }
        
        cell.locationLabel.text = "\(city), \(state), \(country)"
        cell.datesLabel.text = "\(startDate.formatDate()) - \(endDate.formatDate())"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let trip = TripController.shared.fetchedResultsController.object(at: indexPath)
            TripController.shared.deleteTrip(trip: trip)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTripDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? TripDetailViewController else { return }
            let trip = TripController.shared.fetchedResultsController.object(at: indexPath)
            destinationVC.trip = trip
        }
    }
}


// MARK: - NSFetchedResultsControllerDelegate
extension TripListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    // sets behavior for cells
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .fade)
        case .delete:
            tableView.deleteSections(indexSet, with: .fade)
        default: return
        }
    }
    // additional behavior for cells
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath
                else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath
                else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath
                else { return }
            tableView.reloadRows(at: [indexPath], with: .none)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath
                else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        @unknown default:
            fatalError("NSFetchedResultsChangeType has new unhandled cases")
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
