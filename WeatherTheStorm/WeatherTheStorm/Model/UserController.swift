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
    
    static let shared = UserController()
    
    typealias UserName = String
    static let userKey = "UserKey"
    var userName = UserName()
    
    func saveUser(userName: UserName) {
        UserDefaults.standard.set(userName, forKey: UserController.userKey)
    }
    
    func loadUser() {
        guard let savedUser = UserDefaults.standard.string(forKey: UserController.userKey) else { return }
        self.userName = savedUser
    }
    
    
//    var usersName: String {
//        get { UserDefaults.standard.string(forKey: #function) }
//        set { UserDefaults.standard.setValue(newValue, forKey: #function) }
//    }
    

}
