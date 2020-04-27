//
//  AirQuality.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 4/24/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation
import CoreData

extension AirQuality {
    convenience init(index: Int16, moc: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: moc)
        self.index = index
    }
}

extension AirQuality {
    enum CodingKeys: String, CodingKey {
        case mainus
        case pl
    }
}
