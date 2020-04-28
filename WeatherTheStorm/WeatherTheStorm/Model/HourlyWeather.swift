//
//  HourlyWeather_Extension.swift
//  WeatherTheStorm
//
//  Created by Sean Jones on 4/27/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation

struct HourlyForecast: Codable {

    let cloudCoverPercentage: Double
    let feelsLike: Int
    let temp: Int
    let time: String
    
    enum CodingKeys: String, CodingKey{
        
        case cloudCoverPercentage = "clds"
        case feelsLike
        case temp
        case time = "expire_time_gmt"
    }
}
