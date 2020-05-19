//
//  DailyForecast_Extension.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 4/24/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation

struct DailyTopLevelObject: Codable {
    var forecasts: [DailyWeatherForecast]
}

struct DailyWeatherForecast: Codable {
    
    let date: String
    let lowTemp: Int?
    let maxTemp: Int?
    let dow: String
    let day: Day?
       
    enum CodingKeys: String, CodingKey {
        case date = "fcst_valid_local"
        case lowTemp = "min_temp"
        case maxTemp = "max_temp"
        case dow
        case day
    }
}

