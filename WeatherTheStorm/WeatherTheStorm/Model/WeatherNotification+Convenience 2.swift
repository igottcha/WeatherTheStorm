//
//  WeatherNotification+Convenience.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/7/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation.CLLocation

extension WeatherNotification {
    @discardableResult
    convenience init(frequency: [String], isActive: Bool, location: CLLocation, name: String, specificDate: Date, time: Date, trip: Trip?, moc: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: moc)
        self.frequency = frequency
        self.isActive = isActive
        self.location = location
        self.name = name
        self.specificDate = specificDate
        self.time = time
        self.trip = trip
    }
    
}
