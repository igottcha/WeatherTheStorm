//
//  Location.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 4/24/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

enum LocationType: String {
    
    case home = "Home"
    case trip = "Trip"
    
}

extension Location {
   
    @discardableResult
    convenience init(type: String, city: String, state: String, country: String, latitutde: String, longitude: String, weather: Weather?, weatherNotification: [WeatherNotification] = [], moc: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: moc)
        self.type = type
        self.city = city
        self.state = state
        self.country = country
        self.latitude = latitutde
        self.longitude = longitude
        self.weather = weather
    }
    
}



