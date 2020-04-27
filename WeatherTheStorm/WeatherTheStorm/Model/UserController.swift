//
//  UserController.swift
//  WeatherTheStorm
//
//  Created by Sean Jones on 4/27/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation

class UserController {
    
    
    func createUser(name: String) {
         User(name: name)
        saveToPersistentStore()
        
    }
    
    func updateUser(user: User, name: String?) {
        if name != nil { user.name = name}
        saveToPersistentStore()
        
        
    }
    
    func saveToPersistentStore(){
        do{
            try CoreDataStack.context.save()
        }catch{
            print("There was an error saving the data!!! \(#function) \(error.localizedDescription)")
        }
    }
}
