//
//  WeatherNotificationController.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/8/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit
import CoreData

class WeatherNotificationController: NotificationScheduler {
    
    //MARK: - Singleton and Source of Truth
    
    static let shared = WeatherNotificationController()
    var frequencies: [String] = []
    
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
    
    //MARK: - Methods
    
    func toggleIsActive(weatherNotifcation: WeatherNotification) {
        weatherNotifcation.isActive = !weatherNotifcation.isActive
        if weatherNotifcation.isActive {
            scheduleUserNotification(for: weatherNotifcation)
        } else {
            cancelUserNotifications(for: weatherNotifcation)
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    //MARK: - CRUD Functions
    
    func createWeatherNotification(location: Location, name: String) {
        WeatherNotification(location: location, name: name)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func updateWeatherNotification(weatherNotification: WeatherNotification, isActive: Bool, frequency: [String]?, specificDate: Date?, time: Date?) {
        if let frequency = frequency {
            let arrayAsString: String = frequency.description
            let stringAsData = arrayAsString.data(using: String.Encoding.utf16)
            weatherNotification.frequency = stringAsData
        }
        weatherNotification.isActive = isActive
        weatherNotification.specificDate = specificDate
        weatherNotification.time = time
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func deleteWeatherNotificaiton(weatherNotification: WeatherNotification) {
        weatherNotification.managedObjectContext?.delete(weatherNotification)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
}
