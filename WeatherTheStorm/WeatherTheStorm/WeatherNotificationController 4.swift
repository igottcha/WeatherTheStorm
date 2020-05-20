//
//  WeatherNotificationController.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/8/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

protocol NotificationScheduler: class {
    func scheduleUserNotification(for weatherNotification: WeatherNotification)
    func cancelUserNotifications(for weatherNotification: WeatherNotification)
}


extension NotificationScheduler {
    func scheduleUserNotification(for weatherNotification: WeatherNotification) {
        
        guard let location = weatherNotification.location,
            let city = location.city,
            let type = location.type,
            let fireTime = weatherNotification.time,
            let fireDate = weatherNotification.specificDate else { return }
        
        let weather = location.weather ?? Weather(current: nil)
        let weatherPhrase = weather.current?.phrase ?? "partly cloudy"
        let feelsLikeTemp = weather.current?.feelsLike ?? 78
        
        let identifier = "\(city)\(type)"
        
        let tripContent = UNMutableNotificationContent()
        tripContent.title = "Your trip to \(city) is coming up!!!"
        tripContent.body = "Hi \(UserController.shared.userName), it's \(weatherPhrase) in \(city). Feels like \(feelsLikeTemp)°F. Please check app name for clothing recommendations."
        tripContent.sound = UNNotificationSound.default
        
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: fireTime)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: fireDate)
        var components = DateComponents()
        components.year = dateComponents.year
        components.month = dateComponents.month
        components.day = dateComponents.day
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: tripContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("Notification failed")
            } else {
                print("Notification triggered")
            }
        })
        
        if location.type == "Home" {
            let homeContent = UNMutableNotificationContent()
            homeContent.title = "Your weather forecast of \(type)"
            homeContent.body = "Hi \(UserController.shared.userName), it's \(weatherPhrase) at \(type). Feels like \(feelsLikeTemp)°F. Please check app name for clothing recommendations."
            homeContent.sound = UNNotificationSound.defaultCritical
            
            let selectedFrequencies = WeatherNotificationController.shared.frequencies
            
            func getWeekDaySymbol(array: [String]) {
                let week = DateFormatter().calendar.weekdaySymbols
                
                for day in array {
                    let index = week.firstIndex(of: day) ?? 9
                    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .minute, .day], from: fireDate)
                    var dateComponent = DateComponents()
                    components.year = dateComponents.year
                    components.month = dateComponents.month
                    components.day = dateComponents.day
                    components.hour = dateComponents.hour
                    components.minute = dateComponents.minute
                    dateComponent.weekday = Int(day)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
                    let request = UNNotificationRequest(identifier: identifier, content: homeContent, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                        if error != nil {
                            print("Notification failed")
                        } else {
                            print("Notification triggered")
                        }
                    })
                }
            }
            print(getWeekDaySymbol(array: selectedFrequencies))
            
        }
        
    }
    
    func cancelUserNotifications(for weatherNotification: WeatherNotification) {
        guard let location = weatherNotification.location,
            let city = location.city,
            let type = location.type else { return }
        
        let identifier = "\(city)\(type)"
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}

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
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch  {
            print("Error when trying to save. \(error.localizedDescription)\(#function)")
        }
    }
}
