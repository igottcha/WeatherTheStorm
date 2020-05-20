//
//  HomeController.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/8/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation
import CoreData

class HomeController {
    
    static let shared = HomeController()
//    var fetchResultsController: NSFetchedResultsController<Location>
    var homeLocation: [Location] {
        
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        request.predicate = NSPredicate(format: "type == %@", "Home")
        
        let results = try? CoreDataStack.context.fetch(request)
        
        return results ?? []
    }
    
//    init() {
//        request.sortDescriptors = [NSSortDescriptor(key: "city", ascending: true )]
//
//        let resultsController: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
//        fetchResultsController = resultsController
//
//        do {
//            try fetchResultsController.performFetch()
//
//        } catch {
//            print("There Was an error fetching the data, \(error.localizedDescription)\(#function)")
//        }
//    }
    
}
