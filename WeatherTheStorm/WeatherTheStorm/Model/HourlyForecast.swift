//
//  HourlyWeather_Extension.swift
//  WeatherTheStorm
//
//  Created by Sean Jones on 4/27/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation

struct HourlyTopLevelObject: Codable {
    var forecasts: [HourlyForecast]
}

struct HourlyForecast: Codable {

    let cloudCoverPercentage: Double
    let feelsLike: Int
    let temp: Int
    let time: String
    
    enum CodingKeys: String, CodingKey{
        
        case cloudCoverPercentage = "clds"
        case feelsLike = "feels_like"
        case temp
        case time = "fcst_valid_local"
    }
    
    
}


