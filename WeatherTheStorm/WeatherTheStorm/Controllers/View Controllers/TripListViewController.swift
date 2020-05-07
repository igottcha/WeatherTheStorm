//
//  TripListViewController.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 4/28/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit
import CoreData

class TripListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {
    
    //MARK: - Properties
    var trips: [Trip] = []
    
    //MARK: - Outlets
    
    @IBOutlet weak var tripsCollectionView: UICollectionView!
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TripController.shared.fetchedResultsController.delegate = self
        tripsCollectionView.delegate = self
        tripsCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(trips)
        tripsCollectionView.reloadData()
        
    }
    
    //MARK: - Collection View Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TripController.shared.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = tripsCollectionView.dequeueReusableCell(withReuseIdentifier: "tripCell", for: indexPath) as? TripCollectionViewCell else { return UICollectionViewCell() }
        let trip = TripController.shared.fetchedResultsController.object(at: indexPath)
        cell.trip = trip
        cell.getWeather(for: trip)
        
//        cell.locationLabel.text = "Location: \(String(describing: trip.location?.destination?.location))"
//        cell.startDateLabel.text = "Start Date: \(String(describing: trip.startDate))"
//        cell.endDateLabel.text = "End Date: \(String(describing: trip.endDate))"
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toTripDetailVC" {
            guard let indexPath = tripsCollectionView.indexPathsForSelectedItems?.first,
                let destination = segue.destination as? TripDetailViewController
                else { return }
            
            let trip = TripController.shared.fetchedResultsController.object(at: indexPath)
            destination.trip = trip
        }
    }
}

extension TripListViewController: UICollectionViewDelegateFlowLayout {
    
    //Sizing the collection view cell based on screen size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let collectionWidth = tripsCollectionView.bounds.width
        let collectionHeight = tripsCollectionView.bounds.height
        
        return CGSize(width: collectionWidth * 0.95, height: collectionHeight * 0.225)
    }
}
