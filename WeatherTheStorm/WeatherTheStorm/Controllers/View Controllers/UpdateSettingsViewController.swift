//
//  UpdateSettingsViewController.swift
//  WeatherTheStorm
//
//  Created by Sean Jones on 5/19/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class UpdateSettingsViewController: UIViewController {

    //MARK: - Properties
    
    var isSelected = UIImage(systemName: "circle.fill")
    var notSelected = UIImage(systemName: "circle")
    var toggleStateM = 1
    var toggleStateF = 1
    var isMale = true
   
    //MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var updateNameButton: UIButton!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var maleCircle: UIButton!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var femaleCircle: UIButton!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var updateGenderButton: UIButton!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var homeSearchBar: UISearchBar!
    @IBOutlet weak var updateHomeButton: UIButton!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupButtons()
        setupCircles()
        homeSearchBar.delegate = self
    }
    
    //MARK: - Actions
    
    @IBAction func updateNameButtonTapped(_ sender: Any) {
        
        guard let text = nameTextField.text, !text.isEmpty else { return }
               UserController.shared.saveUser(userName: text)
    }
    
    @IBAction func updateGenderButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func updateHomeButtonTapped(_ sender: Any) {
    }
    
    @IBAction func maleButtonIsTapped(_ sender: Any) {
        
        if toggleStateM == 1 {
                  toggleStateM = 2
                  maleCircle.setImage(isSelected, for: .normal)
                  femaleCircle.isEnabled = false
                  maleCircle.isEnabled = true
                  isMale = true
                  UserController.shared.saveGender(gender: true)
              }
              else {
                  toggleStateM = 1
                  maleCircle.setImage(notSelected, for: .normal)
                  femaleCircle.isEnabled = true
                  isMale = false
                  UserController.shared.saveGender(gender: false)
              }
    }
    
    @IBAction func femaleButtonIsTapped(_ sender: Any) {
        
        if toggleStateF == 1 {
                toggleStateF = 2
                femaleCircle.setImage(isSelected, for: .normal)
                maleCircle.isEnabled = false
                femaleCircle.isEnabled = true
                isMale = false
                UserController.shared.saveGender(gender: false)
            }
            else {
                toggleStateM = 1
                femaleCircle.setImage(notSelected, for: .normal)
                maleCircle.isEnabled = true
                isMale = true
                UserController.shared.saveGender(gender: true)
            }
    }
    
    func setupCircles() {
        maleCircle.setImage(UIImage(systemName: "circle"), for: .normal)
        femaleCircle.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    func setupBackground() {
        let  gradientLayer = CAGradientLayer()
             gradientLayer.frame = self.view.bounds
             gradientLayer.colors = [UIColor(named: "HomeControllerTopBG")?.cgColor ?? UIColor.blue.cgColor, UIColor(named: "HomeControllerBottBG")?.cgColor ?? UIColor.cyan]
             self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupButtons() {
        updateHomeButton.layer.cornerRadius = 10
        updateHomeButton.clipsToBounds = true
        
        updateGenderButton.layer.cornerRadius = 10
        updateGenderButton.clipsToBounds = true
        
        updateNameButton.layer.cornerRadius = 10
        updateNameButton.clipsToBounds = true
    }
    
    func setupSearchBar() {
          homeSearchBar.layer.cornerRadius = 15
          homeSearchBar.clipsToBounds = true
       }

}

extension UpdateSettingsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        guard let searchTerm = homeSearchBar.text, !searchTerm.isEmpty else {return}
        LocationController.getPlacemark(searchTerm: searchTerm) { (result) in
            switch (result) {
                
            case .success(let placeMark):
                guard let userHome = LocationController.shared.createLocation(destination: placeMark, type: LocationType.home) else { return }
            
            if userHome.weatherNotification?.count == 0 {
            WeatherNotificationController.shared.createWeatherNotification(location: userHome, name: "Home")
            }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        self.homeSearchBar.endEditing(true)
    }
    
}

extension UpdateSettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    
}
