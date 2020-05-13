//
//  TripController.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 4/27/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit
import CoreData

class TripController {
    
    //MARK: - Properties
    static let shared = TripController()
    
    var fetchedResultsController: NSFetchedResultsController<Trip>
    var tripLocations: [Location] {
        guard let trips: [Trip] = fetchedResultsController.fetchedObjects else { return [] }
        let locations: [Location] = (trips.filter({$0.location != nil}).map({ $0.location }) as! [Location])
        return locations
    }
    
    init() {
        
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        
        let resultsController: NSFetchedResultsController<Trip> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController = resultsController
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error \(error.localizedDescription)")
        }
    }
    
    static func calcNumOfDays(between firstDate: Date, and secondDate: Date) -> Int {
        
        let distance = firstDate.distance(to: secondDate)
        //converted distance from seconds to days and type Int
        return Int(distance / (60 * 60 * 24))

    }
    
    //MARK: - CRUD Function
    
    func createTrip (startDate: Date, endDate: Date, location: Location) {
        Trip(startDate: startDate, endDate: endDate, location: location)
        saveToPersistentStore()
    }
    
    func updateTrip (withTrip trip: Trip, withStartDate startDate: Date, withEndDate endDate: Date, withLocation location: Location) {
        trip.startDate = startDate
        trip.endDate = endDate
        trip.location = location
        saveToPersistentStore()
    }
    
    func deleteTrip (trip: Trip) {
        trip.managedObjectContext?.delete(trip)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch  {
            print("Error when trying to save. \(error.localizedDescription)\(#function)")
        }
    }
}
