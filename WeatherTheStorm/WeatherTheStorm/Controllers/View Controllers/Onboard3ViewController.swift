//
//  Onboard3ViewController.swift
//  WeatherTheStorm
//
//  Created by Sean Jones on 5/8/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class Onboard3ViewController: UIViewController {

    @IBOutlet weak var LiveLabel: UILabel!

    @IBOutlet weak var citySearchBar: UISearchBar!
    
    @IBOutlet weak var whyLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var askLabel: UILabel!
    @IBOutlet weak var bubbleImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLiveLabel()
        setupSearchBar()
        setGradientBackground()
        setupWhyLabel()
        setupProgressLabel()
        setupNextButton()
        citySearchBar.delegate = self
        nextButton.isHidden = true
        hideBubble()
        
        
    }
    
    func hideBubble() {
        bubbleImageView.isHidden = true
       
    }
    
    func setupLiveLabel() {
        UserController.shared.loadUser()
        let userName = UserController.shared.userName
        
        LiveLabel.text = "Where do you live, \(userName)?"
    }
    
    func setupSearchBar() {
       
       citySearchBar.layer.cornerRadius = 15
       citySearchBar.clipsToBounds = true
        
        
    }
    
    func setupProgressLabel() {
        progressLabel.textColor = .white
        progressLabel.text = "3 of 4"
    }
    
    func setupWhyLabel() {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
              let underlineAttributedString = NSAttributedString(string: "Why are we asking?", attributes: underlineAttribute)
             whyLabel.attributedText = underlineAttributedString
        
        whyLabel.isUserInteractionEnabled = true
                     let bubbleTap = UITapGestureRecognizer(target: self, action: #selector(toggleBubble(tap:)))
                      whyLabel.addGestureRecognizer(bubbleTap)
    }
    
    @objc func toggleBubble(tap: UITapGestureRecognizer){
           
           if bubbleImageView.isHidden{
           bubbleImageView.isHidden = false
         
           }
           
           else {
         
               bubbleImageView.isHidden = true
               
           }
           
       }
    
    func setGradientBackground() {
        
        let  gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(named: "HomeControllerTopBG")?.cgColor ?? UIColor.blue.cgColor, UIColor(named: "HomeControllerBottBG")?.cgColor ?? UIColor.cyan]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        
    }
    
    func setupNextButton() {
          nextButton.layer.cornerRadius = 10
          nextButton.clipsToBounds = true
          
      }

}

extension Onboard3ViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
    
        guard let searchTerm = citySearchBar.text, !searchTerm.isEmpty else {return}
        print(searchTerm)
        LocationController.getPlacemark(searchTerm: searchTerm) { (result) in
            switch (result) {
                
            case .success(let placeMark):
                guard let userHome = LocationController.shared.createLocation(destination: placeMark, type: LocationType.home) else { return }
            print(userHome)
            //HomeController.shared.homeLocation = userHome
            
            if userHome.weatherNotification?.count == 0 {
            WeatherNotificationController.shared.createWeatherNotification(location: userHome, name: "Home")
            }
            
            self.nextButton.isHidden = false
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        self.citySearchBar.endEditing(true)
    }
}


