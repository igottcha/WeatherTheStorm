//
//  TripController.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 4/27/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class TripController {
    
    static func calcNumOfDays(between firstDate: Date, and secondDate: Date) -> Int {
        
        let distance = firstDate.distance(to: secondDate)
        //converted distance from seconds to days and type Int
        return Int(distance / (60 * 60 * 24))
    }
    
    //MARK: - CRUD Function
    
    func createTrip (startDate: Date, endDate: Date, location: Location) {
        Trip(startDate: startDate, endDate: endDate, location: location, moc: CoreDataStack.context)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func updateTrip (withTrip trip: Trip, withStartDate startDate: Date, withEndDate endDate: Date, withLocation location: Location) {
        trip.startDate = startDate
        trip.endDate = endDate
        trip.location = location
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
    }
    
    func deleteTrip (trip: Trip) {
        trip.managedObjectContext?.delete(trip)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
}
