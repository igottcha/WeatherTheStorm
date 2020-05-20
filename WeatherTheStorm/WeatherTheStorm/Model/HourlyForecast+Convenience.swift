//
//  HourlyForecast+Convenience.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/14/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation
import CoreData

extension HourlyForecast {
    
    @discardableResult
    convenience init(cloudCoverPercentage: Int64, feelsLike: Int64, temp: Int64, time: String, shortPhrase: String, iconCode: Int64, moc: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: moc)
        self.cloudCoverPercentage = cloudCoverPercentage
        self.feelsLike = feelsLike
        self.temp = temp
        self.time = time
        self.shortPhrase = shortPhrase
        self.iconCode = iconCode
    }
    
}
