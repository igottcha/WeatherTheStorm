//
//  CoreDataStack.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 4/24/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit
import CoreData

enum CoreDataStack {
    
    private static let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    static let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    
}

