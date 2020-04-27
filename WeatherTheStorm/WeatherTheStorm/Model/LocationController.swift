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
    
    var fetchResultsController: NSFetchedResultsController<Location>
    
    //MARK: - Source of truth
    
 init(){
     let request: NSFetchRequest<Location> = Location.fetchRequest()
     
     let resultsController: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
         fetchResultsController = resultsController
     do{
         try fetchResultsController.performFetch()
         
     }catch{
         print("There Was an error fetching the data, \(error.localizedDescription)\(#function)")
     }
 }
    
    //MARK: - CRUD Function
    
    func createLocation(destination: CLPlacemark) {
        Location(destination: destination)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func deleteLocation(location: Location) {
        location.managedObjectContext?.delete(location)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
}
