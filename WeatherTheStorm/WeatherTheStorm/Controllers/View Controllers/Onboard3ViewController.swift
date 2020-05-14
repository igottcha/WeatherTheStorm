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
    
   
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Onboard3ViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
    
        guard let searchTerm = citySearchBar.text, !searchTerm.isEmpty else {return}
        print(searchTerm)
        LocationController.getPlacemark(searchTerm: searchTerm) { (result) in
            switch (result) {
                
            case .success(let placeMark):
            guard let userHome = LocationController.shared.createLocation(destination: placeMark) else { return }
            print(userHome)
            HomeController.shared.homeLocation = userHome
            
            if userHome.weatherNotification?.count == 0 {
            WeatherNotificationController.shared.createWeatherNotification(location: userHome, name: "Home")
            }
            
            self.nextButton.isHidden = false
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}


