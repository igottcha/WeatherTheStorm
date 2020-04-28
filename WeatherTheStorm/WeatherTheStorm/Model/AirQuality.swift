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
