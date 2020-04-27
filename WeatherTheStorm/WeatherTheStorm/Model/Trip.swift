//
//  Trip.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 4/24/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation
import CoreData

extension Trip {
    convenience init(startDate: Date = Date(), endDate: Date = Date(), location: Location, user: User, moc: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: moc)
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.user = user
    }
}

//extension Trip {
//    //Coding Key goes here
//    enum CodingKeys: String, CodingKey {
//        case country
//        case state
//        case city
//    }
//}
