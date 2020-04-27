//
//  CurrentWeather_Extension.swift
//  WeatherTheStorm
//
//  Created by Sean Jones on 4/24/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation
import CoreData


extension CurrentWeather  {
    
    convenience init(feelsLike: Int16, humidity: Int16, precipitationAmount: Double, pressure: Double, uvIndex: Int16, visibility: Int16, windDirection: String, windSpeed: String, phrase: String, moc:  NSManagedObjectContext = CoreDataStack.managedContext ) {
      
        self.init(context:moc)
        self.feelsLike = feelsLike
        self.humidity = humidity
        self.precipitationAmount = precipitationAmount
        self.pressure = pressure
        self.uvIndex = uvIndex
        self.visibility = visibility
        self.windDirection = windDirection
        self.windSpeed = windSpeed
        
    }
    
}

extension CurrentWeather {
    
    enum CodingKeys: String, CodingKey{
    case pressure = "altimeter"
    case feelsLike
    case humidity
    case phrase
    case precipitationAmount = "precip24Hour"
    case temperature
    case uvIndex
    case visibility
    case windSpeed
    case windDirection = "windCompass"
   
    
    }
}

