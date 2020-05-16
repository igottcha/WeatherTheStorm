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
        sortLocations()
    }
    
    //MARK: - Source of truth
    
    init(){
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "city", ascending: true )]
        
        let resultsController: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController = resultsController
        do{
            try fetchResultsController.performFetch()
            
        }catch{
            print("There Was an error fetching the data, \(error.localizedDescription)\(#function)")
        }
    }
    
    //MARK: - Methods
    
    func sortLocations() -> [[Location]] {
        
        var homeLocations: [Location]
        var workLocations: [Location]
        let trips = TripController.shared.tripLocations
        var allLocations: [[Location]] = [[]]
        
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
        
        allLocations.insert(homeLocations, at: 0)
        allLocations.insert(workLocations, at: 1)
        allLocations.insert(trips, at: 2)
        return allLocations
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
    
    func createLocation(destination: CLPlacemark, type: LocationType) -> Location? {
        guard let city = destination.locality, let state = destination.administrativeArea, let country = destination.country, let latitude = destination.location?.coordinate.latitude.description, let longitude = destination.location?.coordinate.longitude.description else { return nil}
        let location = Location(type: type.rawValue, city: city, state: state, country: country, latitutde: latitude, longitude: longitude, weather: nil)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        return location
    }
    
    func deleteLocation(location: Location) {
        location.managedObjectContext?.delete(location)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch  {
            print("Error when trying to save. \(error.localizedDescription)\(#function)")
        }
    }
    
    
}
