//
//  ForecastViewController.swift
//  WeatherTheStorm
//
//  Created by Sean Jones on 4/28/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit
import CoreLocation

class ForecastViewController: UIViewController, CLLocationManagerDelegate {
    
    var date: Date = Date()
    var locationManager: CLLocationManager?
    var userCity: String = ""
      
    
    //MARK:- OUTLETS
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var upArrowImageView: UIImageView!
    
    @IBOutlet weak var swipeUpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupGreetingLabel()
        setupDateLabel()
        setupTempLabel()
        setupFeelsLikelabel()
        setupSwipeUp()
        locationManager = CLLocationManager()
        setupLocationManager()
        
    }
    
    
    func setupLocationManager() {
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])  {
        //var userLocation = CLPlacemark()
        if let clLocation = locations.last {
            print(clLocation.coordinate.latitude)
            let location = CLLocation(latitude: clLocation.coordinate.latitude, longitude: clLocation.coordinate.longitude)
            
            location.fetchCityAndCountry { city, country, error in
                guard let city = city, let country = country, error == nil else { return }
                //print(city + ", " + country)  // Rio de Janeiro, Brazil
                LocationController.shared.getPlacemark(searchTerm: city) { (result) in
                    switch result {
                        
                    case .success(let placeMark):
                        var userLocation = placeMark
                        
                        if userLocation.name != nil{
                            var cityName = userLocation.name!
                            //print("the name of the city is \(cityName)")
                            
                            self.userCity = cityName
                            self.setupGreetingLabel()
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        
                    }
                    
                    
                    
                    
                }
                
            }
            
            
            
        }
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update Failed, \(error)")
    }
    
    func setupGreetingLabel(){
        greetingLabel.text = "Good Morning, \(UserController.shared.userName)! it's a (Phrase Will Go Here) day in \(userCity)"
    }
    
    func setupDateLabel() {
        dateLabel.text = self.date.formatDate()
        
    }
    
    func setupTempLabel(){
        tempLabel.text = "72º"
    }
    
    func setupFeelsLikelabel(){
        
        feelsLikeLabel.text = "Feels like (feels like will go here)"
    }
    
    func setupSwipeUp() {
        upArrowImageView.isUserInteractionEnabled = true
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        swipeGesture.direction = UISwipeGestureRecognizer.Direction.up
        upArrowImageView.addGestureRecognizer(swipeGesture)
        
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.presentPicker))
        //      avatar.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func swipeAction(swipe: UISwipeGestureRecognizer) {
        performSegue(withIdentifier: "toForecastDetail", sender: self)
        print("Swiped")
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
