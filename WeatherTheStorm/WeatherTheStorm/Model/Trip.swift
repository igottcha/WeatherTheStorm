//
//  Trip.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 4/24/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation
import CoreData

extension Trip {
    
    @discardableResult
    convenience init(startDate: Date = Date(), endDate: Date = Date(), location: Location, moc: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: moc)
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
    }
    
}

