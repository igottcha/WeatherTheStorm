//
//  HomeController.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/8/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation
import CoreData

class HomeController {
    
    static let shared = HomeController()
    var homeLocation: [Location] {
        
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        request.predicate = NSPredicate(format: "type == %@", "Home")
        
        let results = try? CoreDataStack.context.fetch(request)
        
        return results ?? []
    }
    
}
