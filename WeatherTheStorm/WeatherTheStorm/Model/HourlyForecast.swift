//
//  HourlyWeather_Extension.swift
//  WeatherTheStorm
//
//  Created by Sean Jones on 4/27/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation

class HourlyTopLevelObject: Codable {
    var forecasts: [HourlyForecast]
    
    init(forecasts: [HourlyForecast]) {
        self.forecasts = forecasts
    }
}

class HourlyForecast: Codable {

    let cloudCoverPercentage: Double
    let feelsLike: Int
    let temp: Int
    let time: String
    
    init(cloudCoverPercentage: Double, feelsLike: Int, temp: Int, time: String){
        self.cloudCoverPercentage = cloudCoverPercentage
        self.feelsLike = feelsLike
        self.temp = temp
        self.time = time
    }
    
    enum CodingKeys: String, CodingKey{
        
        case cloudCoverPercentage = "clds"
        case feelsLike = "feels_like"
        case temp
        case time = "fcst_valid_local"
    }
    
    
}


