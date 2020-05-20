//
//  Weather+Convenience.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/14/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation
import CoreData

extension Weather {
    
    @discardableResult
    convenience init(airQualityIndex: Int64 = 0, current: Current?, hourlyForecasts: [HourlyForecast] = [], dailyForecast: [DailyForecast] = [], moc: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: moc)
        self.airQualityIndex = airQualityIndex
        self.current = current
    }
    
}
