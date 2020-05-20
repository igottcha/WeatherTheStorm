//
//  DailyForecast+Convenience.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/14/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation
import CoreData

extension DailyForecast {
    
    @discardableResult
    convenience init(date: Date = Date(), lowTemp: Int64, maxTemp: Int64, dow: String, chanceOfPrecipitation: Int64, cloudCoverPercentage: Int64, precipitationType: String?, shortPhrase: String?, iconCode: Int64, moc: NSManagedObjectContext = CoreDataStack.context ) {
        self.init(context: moc)
        self.date = date
        self.lowTemp = lowTemp
        self.maxTemp = maxTemp
        self.dow = dow
        self.chanceOfPrecipitation = chanceOfPrecipitation
        self.cloudCoverPercentage = cloudCoverPercentage
        self.precipitationType = precipitationType
        self.shortPhrase = shortPhrase
        self.iconCode = iconCode
    }
    
}
