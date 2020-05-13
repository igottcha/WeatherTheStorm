//
//  CoreDataStack.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 4/24/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import CoreData

enum CoreDataStack {
    
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherTheStorm")
        
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persisttent stores \(error)")
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext {
        return container.viewContext
    }
}
