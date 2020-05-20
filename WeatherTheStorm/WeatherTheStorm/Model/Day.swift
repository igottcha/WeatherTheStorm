//
//  DayExtension.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 4/24/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation

struct Day: Codable {
    
    let chanceOfPrecipitation: Int
    let cloudCoverPercentage: Int
    let precipitationType: String
    let shortPhrase: String
    let iconCode: Int
    
    enum CodingKeys: String, CodingKey {
        case chanceOfPrecipitation = "pop"
        case cloudCoverPercentage = "clds"
        case precipitationType = "precip_type"
        case shortPhrase = "phrase_32char"
        case iconCode = "icon_code"
    }
    
}


