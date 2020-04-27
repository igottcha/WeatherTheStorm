//
//  UserController.swift
//  WeatherTheStorm
//
//  Created by Sean Jones on 4/27/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit
import CoreData

class UserController {
    
    var fetchResultsController: NSFetchedResultsController<User>
       
       //MARK: - Source of truth
       
    init(){
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        let resultsController: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController = resultsController
        do{
            try fetchResultsController.performFetch()
            
        }catch{
            print("There Was an error fetching the data, \(error.localizedDescription)\(#function)")
        }
    }
    
    //MARK: - CRUD FUNCTION
    
    func createUser(name: String) {
        User(name: name)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        //saveToPersistentStore()
        
    }
    
    func updateUser(user: User, name: String?) {
        if name != nil { user.name = name}
        //saveToPersistentStore()
        
    }
    
//    func saveToPersistentStore(){
//        do{
//            try CoreDataStack.context.save()
//        }catch{
//            print("There was an error saving the data!!! \(#function) \(error.localizedDescription)")
//        }
//    }
}
