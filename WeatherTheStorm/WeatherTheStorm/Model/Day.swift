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
    let cloudCoverPercent: Int
    let precipitationType: String
    let shortPhrase: String
    
    
    enum CodingKeys: String, CodingKey {
        case chanceOfPrecipitation = "pop"
        case cloudCoverPercent = "clds"
        case precipitationType = "precip_type"
        case shortPhrase = "phrase_32char"
    }
}


