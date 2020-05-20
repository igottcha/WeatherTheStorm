//
//  AirQuality.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 4/24/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation

struct AirQuality: Codable {
    
    let index: Int
    
    enum CodingKeys: String, CodingKey {
        case index = "aqius"
    }
    
}

struct AQITopLevelObject: Codable {
    
    var data: AQIData
    
}

struct AQIData: Codable {
    
    var current: AQICurrent
    
}

struct AQICurrent: Codable {
    
    var pollution: AirQuality
    
}

