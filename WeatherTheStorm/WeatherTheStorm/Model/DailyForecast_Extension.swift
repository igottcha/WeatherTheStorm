//
//  DailyForecast_Extension.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 4/24/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation
import CoreData

extension DailyForecast {
    
    enum CodingKeys: String, CodingKey {
        case lowTemp = "min_temp"
        case maxTemp = "max_temp"
        case dow
    }
}

extension DailyForecast {
    @discardableResult
    convenience init(lowTemp: Int16, maxTemp: Int16, dow: String, moc: NSManagedObjectContext = CoreDataStack.managedContext) {
        
        self.init(context: moc)
        self.lowTemp = lowTemp
        self.maxTemp = maxTemp
        self.dow = dow
    }
}
