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
    var userIsMale: Bool?
    var userName = ""
    var menuIsOut = false
    
    
    
    //MARK:- OUTLETS
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var upArrowImageView: UIImageView!
    @IBOutlet weak var hourleForecastCollectionView: UICollectionView!
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var HighLabel: UILabel!
    @IBOutlet weak var LowLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var settingsMenuViewLeading: NSLayoutConstraint!
    @IBOutlet weak var settingsMenuViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var settingsMenuView: UIView!
    @IBOutlet weak var changeClothesLabel: UILabel!
    @IBOutlet weak var changeNameLabel: UILabel!
    @IBOutlet weak var creditsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        setupDateLabel()
        setupSwipeUp()
        grabUserDetails()
        hourleForecastCollectionView.delegate = self
        hourleForecastCollectionView.dataSource = self
        setupMenu()
        setupCollectionView()
        setupBottomContainer()
        setupChangeClothesLabel()
        setupChangeNameLabel()
        setupCreditsLabel()
        
        
    }
    
    @IBAction func gearButtonTapped(_ sender: Any) {
        
        print("tapped")
        if menuIsOut == false {
            
            
            settingsMenuViewTrailing.constant = 200
            settingsMenuViewLeading.constant  = 0
            settingsMenuView.isHidden = false
            menuIsOut = true
            
        } else {
            
            settingsMenuViewTrailing.constant = -5
            settingsMenuViewLeading.constant  = -200
            menuIsOut = false
            settingsMenuView.isHidden = true
            
        }
        
    }
    
    func setupChangeClothesLabel(){
        changeClothesLabel.text = "Change Clothing Preference"
        
    }
    
    func setupCreditsLabel() {
        creditsLabel?.text = "Weather Wear created by Brendan Smith, Chris Gottfredson, Hin Wong, Jon Bellio, and Sean Jones"
    }
    
    func setupChangeNameLabel() {
        changeNameLabel.text = "Change your name"
    }
    func setupMenu() {
        self.menuIsOut = false
        settingsMenuView.isHidden = true
        settingsMenuViewTrailing.constant = -5
        settingsMenuViewLeading.constant  = -200
        
    }
    
    func grabUserDetails() {
        getUserCity()
        getUserName()
        getUserGender()
        
        
    }
    
    func getUserCity() {
        let home = HomeController.shared.homeLocation.first
        self.location = home
        setLocationWeather(home: self.location!)
        setupCityLabel()
        
        
        
    }
    
    
    
  
     func toggleMenu(tap: UITapGestureRecognizer){
        
        
    }
    
    func setupCityLabel() {
        
        guard let cityName = self.location?.city else {return}
        cityLabel.textColor = .white
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "\(cityName)", attributes: underlineAttribute)
        cityLabel.attributedText = underlineAttributedString
        self.userCity = cityName
    }
    
    func getUserName() {
        UserController.shared.loadUser()
        self.userName = UserController.shared.userName
        
    }
    
    func getUserGender() {
        UserController.shared.loadGender()
        self.userIsMale = UserController.shared.isMale
        
        
    }
    
    func setLocationWeather(home: Location) {
        HourlyWeatherController.fetchForecast(location: home) { (result) in
            switch (result){
                
            case .success(let hourlyForecasts):
                
                DispatchQueue.main.async {
                    self.hourleForecastCollectionView.reloadData()
                    CurrentWeatherController.fetchForecast(location: home) { (result) in
                        switch (result) {
                            
                        case .success(_):
                            DispatchQueue.main.async {
                                self.setupTempLabel()
                                self.setupFeelsLikelabel()
                                self.setupPhrase()
                                self.setupGreetingLabel()
                                
                                //self.setupHighLowLabels()
                                DailyForecastController.fetchForecast(location: home, firstDate: Date() + 1, secondDate: Date() + 10) { (result) in
                                    
                                    switch (result){
                                        
                                    case .success(let dailyForecasts):
                                        DispatchQueue.main.async {
                                            
                                            self.setupHighLowLabels()
                                            AirQualityController.shared.fetchAQI(location: home) { (result) in
                                                switch (result) {
                                                    
                                                case .success(let AQI):
                                                    print(AQI)
                                                //self.location?.weather?.airQualityIndex = Int64(AQI)
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
    
    
    func setupHighLowLabels() {
        HighLabel.textColor = .white
        LowLabel.textColor = .white
        
        guard let today = location?.weather?.dailyForecasts?.object(at: 0) as? DailyForecast else {return}
        
        if today.lowTemp == nil || today.maxTemp == nil
        {
            HighLabel.isHidden = true
            LowLabel.isHidden = true
        }
        else {
            HighLabel.text = "\(String(today.maxTemp))"
            LowLabel.text = "\(String(today.lowTemp))"
        }
        
    }
    
    
    
    func setupGreetingLabel(){
        greetingLabel.text = "Hello, \(UserController.shared.userName)! it's a \(phrase) day in \(userCity)"
        greetingLabel.textColor = .white
        
    }
    
    func setupDateLabel() {
        dateLabel.text = self.date.formatDate()
        dateLabel.textColor = .white
        
    }
    
    func setupTempLabel(){
        guard let currentTemp = self.location?.weather?.current?.temperature else {return}
        tempLabel.text = "\(currentTemp)º"
        tempLabel.textColor = .white
    }
    
    func setupFeelsLikelabel(){
        guard let feelLike = self.location?.weather?.current?.feelsLike else {return}
        feelsLikeLabel.text = "Feels like \(feelLike)º"
        feelsLikeLabel.textColor = .white
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
    
    func setGradientBackground() {
        
        let  gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(named: "HomeControllerTopBG")?.cgColor ?? UIColor.blue.cgColor, UIColor(named: "HomeControllerBottBG")?.cgColor ?? UIColor.cyan]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        
    }
    
    func setupCollectionView() {
        hourleForecastCollectionView.layer.cornerRadius = 5
        hourleForecastCollectionView.clipsToBounds = true
    }
    
    func setupBottomContainer() {
        bottomContainer.backgroundColor = UIColor(named: "HomeForecastBottomContainer")
        bottomContainer.layer.cornerRadius = 15
        bottomContainer.clipsToBounds = true
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toForecastDetail" {
            if let destinationVC = segue.destination as? ForecastDetailViewController {
                let  location = self.location
                let userIsMale = self.userIsMale
                let userCity = self.userCity
                let userName = self.userName
                destinationVC.location = location
                destinationVC.userIsMale = userIsMale
                destinationVC.userName = userName
                destinationVC.userCity = userCity
            }
        }
    }
    
    
}

extension ForecastViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let hourliesCount = self.location?.weather?.hourlyForecasts?.count else {return 0}
        return hourliesCount
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = hourleForecastCollectionView.dequeueReusableCell(withReuseIdentifier: "hourlyForecastCell", for: indexPath) as? HourlyForecastCollectionViewCell else {return UICollectionViewCell()}
        
        guard let location = self.location else {return cell}
        
        guard let hourlyWeather = location.weather?.hourlyForecasts?[indexPath.row] as? HourlyForecast else {return cell}
        let time = stringToDate(hourlyWeather.time ?? "12:00")
        let hour = time.hour()
        
        
        cell.hourlyTimeLabel.text = hour
        cell.hourlyTempLabel.text = "\(String(hourlyWeather.temp))º"
        
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.height
        let layout = hourleForecastCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        return layout.itemSize
    }
    
    
    
}



