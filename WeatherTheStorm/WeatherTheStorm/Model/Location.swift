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

extension Location {
    @discardableResult
    convenience init(destination: CLPlacemark, weather: Weather?, weatherNotification: [WeatherNotification] = [], moc: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: moc)
        self.destination = destination
        self.weather = weather
    }
}



