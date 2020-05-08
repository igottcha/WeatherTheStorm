//
//  DayOfTheWeek.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/6/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation

//MARK: - May not need this Class...

public class DayOfTheWeek: NSObject {
    
    let sunday: String
    let monday: String
    let tuesday: String
    let wednesday: String
    let thursday: String
    let friday: String
    let saturday: String
    
    init(sunday: String, monday: String, tuesday: String, wednesday: String, thursday: String, friday: String, saturday: String) {
        self.sunday = sunday
        self.monday = monday
        self.tuesday = tuesday
        self.wednesday = wednesday
        self.thursday = thursday
        self.friday = friday
        self.saturday = saturday
    }
    
}
