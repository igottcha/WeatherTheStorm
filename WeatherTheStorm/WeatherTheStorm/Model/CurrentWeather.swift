//
//  CurrentWeather_Extension.swift
//  WeatherTheStorm
//
//  Created by Sean Jones on 4/27/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//


import Foundation

struct CurrentWeather: Codable  {
    
    let pressure: Double
    let feelsLike: Int
    let humidity: Int
    let phrase: String
    let precipitationAmount: Double
    let temperature: Int
    let uvIndex: Int
    let visibility: Int
    let windSpeed: Int
    let windDirection: String
    let sunrise: String
    let sunset: String
    let iconCode: Int
    
    enum CodingKeys: String, CodingKey{
        case pressure = "pressureAltimeter"
        case feelsLike = "temperatureFeelsLike"
        case humidity = "relativeHumidity"
        case phrase = "cloudCoverPhrase"
        case precipitationAmount = "precip24Hour"
        case temperature
        case uvIndex
        case visibility
        case windSpeed
        case windDirection = "windDirectionCardinal"
        case sunrise = "sunriseTimeLocal"
        case sunset = "sunsetTimeLocal"
        case iconCode = "iconCode"
        
   
    
    }
}


