//
//  HourlyWeather_Extension.swift
//  WeatherTheStorm
//
//  Created by Sean Jones on 4/24/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation
import CoreData

extension HourlyForecast {
    convenience init(cloudCoverPercentage: Double, feelsLike: Int16, temp: Int16, time: String, moc: NSManagedObjectContext = CoreDataStack.managedContext) {
        self.init(context: moc)
        self.cloudCoverPercentage = cloudCoverPercentage
        self.feelsLike = feelsLike
        self.temp = temp
        self.time = time
    }
}

extension HourlyForecast {
    
    enum CodingKeys: String, CodingKey{
        
        case cloudCoverPercentage = "clds"
        case feelsLike
        case temp
        case time = "expire_time_gmt"
    }
}



