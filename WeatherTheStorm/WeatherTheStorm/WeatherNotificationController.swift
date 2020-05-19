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
            let type = location.type else { return }
        
        let content = getContent(location: location, userName: UserController.shared.userName)
        content.sound = UNNotificationSound.default
        let triggers = getTrigger(type: type, fireDate: weatherNotification.specificDate, fireTime: weatherNotification.time, frequencyData: weatherNotification.frequency)
        
        for trigger in triggers {
            guard let index = triggers.firstIndex(of: trigger) else { return }
            let identifier = "\(city)\(type)\(index)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                if error != nil {
                    print("Notification failed")
                } else {
                    print("Notification triggered")
                }
            })
        }
    }
    
    func cancelUserNotifications(for weatherNotification: WeatherNotification) {
        guard let location = weatherNotification.location,
            let city = location.city,
            let type = location.type else { return }
        var identifiers: [String] = []
        
        switch type {
        case "Home":
            guard let data = weatherNotification.frequency else { return }
            var days: [String] = []
            do {
                days = try JSONDecoder().decode([String].self, from: data)
            } catch {
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
            }
            for day in days {
                guard let index = days.firstIndex(of: day) else { return }
                identifiers.append("\(city)\(type)\(index)")
            }
        case "Trip":
            identifiers.append("\(city)\(type)\(0)")
        default:
            print("No identifiers identified in \(#function)")
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        
    }
    
    private func getContent(location: Location, userName: String) -> UNMutableNotificationContent {
        guard let type = location.type,
            let city = location.city else { return UNMutableNotificationContent() }
        
        let weather = location.weather ?? Weather(current: nil)
        let weatherPhrase = weather.current?.phrase ?? "partly cloudy"
        let feelsLikeTemp = weather.current?.feelsLike ?? 78
        let content = UNMutableNotificationContent()
        
        switch type {
        case "Home":
            content.title = "Your weather forecast of \(type)"
            content.body = "Hi \(userName), it's \(weatherPhrase) at \(type). Feels like \(feelsLikeTemp)°F. Please check app name for clothing recommendations."
        case "Trip":
            content.title = "Your trip to \(city) is coming up!!!"
            content.body = "Hi \(userName), it's \(weatherPhrase) in \(city). Feels like \(feelsLikeTemp)°F. Please check app name for clothing recommendations."
        default:
            print("Location Type does not exist")
        }
        print(content)
        return content
    }
    
    private func getTrigger(type: String, fireDate: Date?, fireTime: Date?, frequencyData: Data?) -> [UNCalendarNotificationTrigger] {
        guard let fireTime = fireTime else { return [] }
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: fireTime)
        var triggers: [UNCalendarNotificationTrigger] = []
        
        switch type {
        case "Home":
            guard let data = frequencyData else { return [] }
            var days: [String] = []
            
            do {
                days = try JSONDecoder().decode([String].self, from: data)
            } catch {
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
            }
            
            for day in days {
                let week = DateFormatter().calendar.weekdaySymbols
                let index = week.firstIndex(of: day) ?? 9
                var dateComponents = DateComponents()
                dateComponents.weekday = index + 1
                dateComponents.hour = timeComponents.hour
                dateComponents.minute = timeComponents.minute
                triggers.append(UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true))
            }
        case "Trip":
            guard let fireDate = fireDate else { return [] }
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: fireDate)
            var components = DateComponents()
            components.year = dateComponents.year
            components.month = dateComponents.month
            components.day = dateComponents.day
            components.hour = timeComponents.hour
            components.minute = timeComponents.minute
            
            triggers.append(UNCalendarNotificationTrigger(dateMatching: components, repeats: false))
        default:
            print("Location Type does not exist")
        }
        
        print(triggers)
        return triggers
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
