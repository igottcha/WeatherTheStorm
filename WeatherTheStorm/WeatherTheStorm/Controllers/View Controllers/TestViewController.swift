//
//  TestViewController.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 4/28/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

//MARK: - Outlets
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var welcomeLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        UserController.shared.loadUser()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        welcomeLabel.text = "Hello, \(UserController.shared.userName)"
    }
    //MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let text = userNameTextField.text, !text.isEmpty else { return }
        UserController.shared.saveUser(userName: text)
    }
    
    func updateViews() {
        
    }
    
}

