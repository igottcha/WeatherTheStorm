//
//  Current+Convenience.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/14/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation
import CoreData

extension Current {
    @discardableResult
    convenience init(pressure: Double, feelsLike: Int64, humidity: Int64, phrase: String, precipitationAmount: Double, temperature: Int64, uvIndex: Int64, visibility: Int64, windSpeed: Int64, windDirection: String, sunrise: Date = Date(), sunset: Date = Date(), moc: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: moc)
        self.pressure = pressure
        self.feelsLike = feelsLike
        self.humidity = humidity
        self.phrase = phrase
        self.precipitationAmount = precipitationAmount
        self.temperature = temperature
        self.uvIndex = uvIndex
        self.visibility = visibility
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.sunrise = sunrise
        self.sunset = sunset
        
    }
}
