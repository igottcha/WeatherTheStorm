//
//  Location.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 4/24/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation
import CoreData

extension Location {
    convenience init(destination: String, moc: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: moc)
        self.destination = destination
    }
}

extension Location {
    enum CodingKeys: String, CodingKey {
        case location
    }
}
