//
//  LocationController.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 4/27/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class LocationController {

    static let shared = LocationController()
    var fetchResultsController: NSFetchedResultsController<Location>
    var tripLocations: [Location]?
    var sortedLocations: [[Location]]? {
        didSet {
            sortLocations()
        }
    }
    
    //MARK: - Source of truth
    
 init(){
     let request: NSFetchRequest<Location> = Location.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "destination", ascending: true )]
     
     let resultsController: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
         fetchResultsController = resultsController
     do{
         try fetchResultsController.performFetch()
         
     }catch{
         print("There Was an error fetching the data, \(error.localizedDescription)\(#function)")
     }
 }

    //MARK: - Methods
    
    func sortLocations() {
    
        var homeLocations: [Location]
        var workLocations: [Location]
        let trips = TripController.shared.tripLocations
        
        if let homeLocation = HomeController.shared.homeLocation {
          homeLocations = [homeLocation]
        } else {
            homeLocations = []
        }
        
        if let workLocation = WorkController.shared.workLocation {
          workLocations = [workLocation]
        } else {
            workLocations = []
        }
        
        sortedLocations?.append(homeLocations)
        sortedLocations?.append(workLocations)
        sortedLocations?.append(trips)
    }
    
    //MARK: - GeoCoding
    
    static func getPlacemark(searchTerm: String, completion: @escaping (Result<CLPlacemark, LocationError>) -> Void) {
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(searchTerm) { (placemarks, error) in
            if let error = error {
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
                completion(.failure(.thrown(error)))
                return
            }
            
            guard let placemark = placemarks?.first else { completion(.failure(.unableToFindLocation)); return }
                        
            completion(.success(placemark))
            return
        }
    }
    
    //MARK: - CRUD Function
    
    func createLocation(destination: CLPlacemark) -> Location {
       let location = Location(destination: destination, weather: nil)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    return location
    }
    
    func deleteLocation(location: Location) {
        location.managedObjectContext?.delete(location)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
}
