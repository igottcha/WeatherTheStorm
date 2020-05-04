//
//  DateExtension.swift
//  WeatherTheStorm
//
//  Created by Sean Jones on 4/28/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation

extension Date {
    func month() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: self)
    }
    
    func day() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: self)
    }
    
    //formats a date into a string using dateStyle.short
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: self)
    }
}
