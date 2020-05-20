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
    typealias IsMale = Bool
    static let genderKey = "genderKey"
    var userName = UserName()
    var isMale = IsMale()
    
    func saveUser(userName: UserName) {
        UserDefaults.standard.set(userName, forKey: UserController.userKey)
    }
    
    func loadUser() {
        guard let savedUser = UserDefaults.standard.string(forKey: UserController.userKey) else { return }
        self.userName = savedUser
    }
    
    func saveGender(gender: IsMale) {
        UserDefaults.standard.set(gender, forKey: UserController.genderKey)
        self.isMale = gender
    }
    
    func loadGender() {
        let savedGender = UserDefaults.standard.bool(forKey: UserController.genderKey)
        self.isMale = savedGender
    }
    
    
//    var usersName: String {
//        get { UserDefaults.standard.string(forKey: #function) }
//        set { UserDefaults.standard.setValue(newValue, forKey: #function) }
//    }
    

}
