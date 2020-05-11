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
    
    var location: Location?
    var date: Date = Date()
    var locationManager: CLLocationManager?
    var userCity: String = ""
    var phrase: String = ""
    
    
    
    //MARK:- OUTLETS
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var upArrowImageView: UIImageView!
    @IBOutlet weak var swipeUpLabel: UILabel!
    @IBOutlet weak var hourleForecastCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupGreetingLabel()
        setupDateLabel()
        
        setupFeelsLikelabel()
        setupSwipeUp()
        locationManager = CLLocationManager()
        setupLocationManager()
        hourleForecastCollectionView.delegate = self
        hourleForecastCollectionView.dataSource = self
        setupCollectionViewCells()
        
        
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
            getCity(location: location)
            
        }
        
    }
    
    func getCity(location: CLLocation) {
        location.fetchCityAndCountry { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            //print(city + ", " + country)  // Rio de Janeiro, Brazil
            LocationController.getPlacemark(searchTerm: city) { (result) in
                switch result {
                    
                case .success(let placeMark):
                    let userLocation = placeMark
                    
                    if userLocation.name != nil{
                        let cityName = userLocation.name!
                        let weatherLocation = LocationController.shared.createLocation(destination: placeMark)
                        self.location = weatherLocation
                        self.userCity = cityName
                        //self.setupGreetingLabel()
                        if self.location != nil { self.getWeather(location: self.location!)}
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
                
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update Failed, \(error)")
    }
    
    func setupGreetingLabel(){
        greetingLabel.text = "Good Morning, \(UserController.shared.userName)! it's a \(phrase) day in \(userCity)"
    }
    
    func setupDateLabel() {
        dateLabel.text = self.date.formatDate()
        
    }
    
    func setupTempLabel(){
        guard let currentTemp = self.location?.weather?.current?.temperature else {return}
        tempLabel.text = "\(currentTemp)º"
    }
    
    func setupFeelsLikelabel(){
        guard let feelLike = self.location?.weather?.current?.feelsLike else {return}
        feelsLikeLabel.text = "Feels like \(feelLike)º"
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
    
    func getWeather(location: Location){
        HourlyWeatherController.fetchForecast(location: location) { (result) in
            switch (result){
                
            case .success(_):
                DispatchQueue.main.async {
                    self.hourleForecastCollectionView.reloadData()
                    CurrentWeatherController.fetchForecast(location: location) { (result) in
                        switch (result){
                            
                        case .success(_):
                            DispatchQueue.main.async {
                            self.setupTempLabel()
                            self.setupFeelsLikelabel()
                            self.setupPhrase()
                            self.setupGreetingLabel()
                            }
                        case .failure(_):
                            break
                        }
                    }
                }
                
                
            case .failure(_):
                break
            }
        }
    }
    
    func setupCollectionViewCells() {
        let width = view.frame.size.width / 3
        let layout = hourleForecastCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    func stringToDate(_ dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = formatter.date(from: dateString) else { return Date()}
        return date
        
    }
    func setupPhrase(){
        guard let weatherPhrase = self.location?.weather?.current?.phrase else {return}
        self.phrase = weatherPhrase
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

extension ForecastViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let hourliesCount = self.location?.weather?.hourlyForecasts?.count else {return 0}
        return hourliesCount
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = hourleForecastCollectionView.dequeueReusableCell(withReuseIdentifier: "hourlyForecastCell", for: indexPath) as? HourlyForecastCollectionViewCell else {return UICollectionViewCell()}
        
        guard let location = self.location else {return cell}
        
        guard let hourlyWeather = location.weather?.hourlyForecasts?[indexPath.row] else {return cell}
        let time = stringToDate(hourlyWeather.time)
        let hour = time.hour()
        
        
        cell.hourlyTimeLabel.text = hour
        cell.hourlyTempLabel.text = "\(String(hourlyWeather.temp))º"
        
        
        return cell
    }
    
    
}



