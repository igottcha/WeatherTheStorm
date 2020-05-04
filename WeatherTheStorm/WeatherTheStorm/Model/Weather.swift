//
//  Weather.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 4/28/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let day: Day
    let current: CurrentWeather
    let hourly: HourlyForecast
}
