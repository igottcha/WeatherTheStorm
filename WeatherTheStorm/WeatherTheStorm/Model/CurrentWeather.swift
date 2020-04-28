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
    let windSpeed: String
    let windDirection: String
    
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

