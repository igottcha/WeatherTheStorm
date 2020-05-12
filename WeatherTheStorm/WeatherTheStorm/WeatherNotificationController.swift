//
//  WeatherNotificationController.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/8/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation

class WeatherNotificationController {
    
    static let shared = WeatherNotificationController()
    var notifications: [WeatherNotification] = []
    
    let daysOfTheWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
}
