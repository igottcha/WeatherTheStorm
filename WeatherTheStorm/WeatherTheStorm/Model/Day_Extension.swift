//
//  DayExtension.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 4/24/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation
import CoreData

extension Day {
    
    enum CodingKeys: String, CodingKey {
        case chanceOfPrecipitation = "pop"
        case cloudCoverPercent = "clds"
        case precipitationType = "precip_type"
    }
}

extension Day {
    @discardableResult
    convenience init(chanceOfPrecipitation: Int16, cloudCoverPercent: Double, precipitationType: String, moc: NSManagedObjectContext = CoreDataStack.managedContext) {
        self.init(context: moc)
        self.chanceOfPrecipitation = chanceOfPrecipitation
        self.cloudCoverPercent = cloudCoverPercent
        self.precipitationType = precipitationType
    
    }
}
