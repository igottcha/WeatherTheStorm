//
//  TripListViewController.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 4/28/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit
import CoreData

class TripListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    //MARK: - Properties
    var trips: [Trip] = []
    
    //MARK: - Outlets
    @IBOutlet weak var tripsTableView: UITableView!
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TripController.shared.fetchedResultsController.delegate = self
        tripsTableView.delegate = self
        tripsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(trips)
        tripsTableView.reloadData()
    }
    
    //MARK: - Table View Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TripController.shared.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tripsTableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath) as? TripTableViewCell else { return UITableViewCell() }
        let trip = TripController.shared.fetchedResultsController.object(at: indexPath)
        
        cell.trip = trip
        
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toTripDetailVC" {
            guard let indexPath = tripsTableView.indexPathForSelectedRow, let destination = segue.destination as? TripDetailViewController
            else { return }

            let trip = TripController.shared.fetchedResultsController.object(at: indexPath)
            destination.trip = trip
        }
    }
}

