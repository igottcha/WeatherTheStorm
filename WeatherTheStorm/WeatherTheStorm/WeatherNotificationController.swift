//
//  WeatherNotificationController.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/8/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit
import CoreData

class WeatherNotificationController {
    
    //MARK: - Singleton and Source of Truth
    
    static let shared = WeatherNotificationController()
    var frequencies: [String] = []
    
    let daysOfTheWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var fetchedResultsController: NSFetchedResultsController<WeatherNotification>
    
    init() {
        
        let fetchRequest: NSFetchRequest<WeatherNotification> = WeatherNotification.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let resultsController: NSFetchedResultsController<WeatherNotification> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController = resultsController
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
        }
    }
    
    
    //MARK: - CRUD Functions
    
    func createWeatherNotification(location: Location, name: String) {
        WeatherNotification(location: location, name: name)
        saveToPersistentStore()
    }
    
    func updateWeatherNotification(weatherNotification: WeatherNotification, isActive: Bool, frequency: [String]?, specificDate: Date?, time: Date?) {
        weatherNotification.isActive = isActive
        weatherNotification.frequency = frequency
        weatherNotification.specificDate = specificDate
        weatherNotification.time = time
        saveToPersistentStore()
    }
    
    func deleteWeatherNotificaiton(weatherNotification: WeatherNotification) {
        weatherNotification.managedObjectContext?.delete(weatherNotification)
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
