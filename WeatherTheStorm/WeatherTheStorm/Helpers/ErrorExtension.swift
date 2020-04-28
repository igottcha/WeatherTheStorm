//
//  ErrorExtension.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 4/28/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation

enum LocationError: LocalizedError {
    
    case thrown(Error)
    case unableToFindLocation
    
}
