//
//  StringExtension.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/16/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation

extension String {
    
    func stringToDate() -> Date {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = formatter.date(from: self) else { return Date()}
        return date
    }
    
}
