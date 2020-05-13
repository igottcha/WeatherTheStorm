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
    @IBOutlet weak var nameQuestionLabel: UILabel!
    
    @IBOutlet weak var whyLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        setupWelcomeLabel()
        setupNameQuestionLabel()
        UserController.shared.loadUser()
       setupWhyAsking()
        setupProgressLabel()
        setupNextButton()
        
        
       
    }
    
   
    
    
    //MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let text = userNameTextField.text, !text.isEmpty else { return }
        UserController.shared.saveUser(userName: text)
        performSegue(withIdentifier: "toGenderSelectionVC", sender: self)
    }
    
    func setupWhyAsking() {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Why are we asking?", attributes: underlineAttribute)
       whyLabel.attributedText = underlineAttributedString
       
    }
    
    func setupWelcomeLabel() {
        welcomeLabel.text = "Hello! Thank you for using Weather or Not. Before you get started, we just have a couple of questions."
    }
    
    func setGradientBackground() {
        
        let  gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(named: "HomeControllerTopBG")?.cgColor ?? UIColor.blue.cgColor, UIColor(named: "HomeControllerBottBG")?.cgColor ?? UIColor.cyan]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        
    }
    
    func setupNameQuestionLabel() {
        nameQuestionLabel.text  = "What is your name?"
        nameQuestionLabel.textColor = .white
    
        
    }
    
    func setupTextField() {
        
        userNameTextField.layer.cornerRadius = 30
        userNameTextField.clipsToBounds = true
    }
    
    func setupProgressLabel() {
        progressLabel.textColor = .white
        progressLabel.text = "1 of 4"
    }
    
    func setupNextButton() {
        nextButton.layer.cornerRadius = 10
        nextButton.clipsToBounds = true
        
    }
    
}

