//
//  HourlyWeather_Extension.swift
//  WeatherTheStorm
//
//  Created by Sean Jones on 4/27/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation

class HourlyTopLevelObject: Codable {
    
    var forecasts: [HourlyWeatherForecast]
    
    init(forecasts: [HourlyWeatherForecast]) {
        self.forecasts = forecasts
    }
    
}

class HourlyWeatherForecast: Codable {

    let cloudCoverPercentage: Double
    let feelsLike: Int
    let temp: Int
    let time: String
    let shortPhrase: String
    let iconCode: Int
    
    init(cloudCoverPercentage: Double, feelsLike: Int, temp: Int, time: String, shortPhrase: String, iconCode: Int){
        self.cloudCoverPercentage = cloudCoverPercentage
        self.feelsLike = feelsLike
        self.temp = temp
        self.time = time
        self.shortPhrase = shortPhrase
        self.iconCode = iconCode
    }
    
    enum CodingKeys: String, CodingKey{
        
        case cloudCoverPercentage = "clds"
        case feelsLike = "feels_like"
        case temp
        case time = "fcst_valid_local"
        case shortPhrase = "phrase_32char"
        case iconCode = "icon_code"
    }
    
}


