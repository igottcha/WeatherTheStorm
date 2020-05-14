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
    var userName: String?
    
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        setupDateLabel()
        setupSwipeUp()
        grabUserDetails()
        hourleForecastCollectionView.delegate = self
        hourleForecastCollectionView.dataSource = self
        
        setupCollectionView()
        setupBottomContainer()
        
        
        
    }
    
    func grabUserDetails() {
        getUserCity()
        getUserName()
        getUserGender()
        
        
    }
    
    func getUserCity() {
        let home = HomeController.shared.homeLocation
        self.location = home
        setLocationWeather(home: self.location!)
        setupCityLabel()
        
        
        
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
                
            case .success(_):
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
                                DailyForecastController.fetchForecast(location: home, firstDate: Date(), secondDate: Date() + 10) { (result) in
                                    switch (result){
                                        
                                    case .success(let dailyForecasts):
                                        DispatchQueue.main.async {
                                        //self.location?.weather?.dailyForecasts = NSOrderedSet(array: dailyForecasts.forecasts)
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
        let todaysHigh = today.maxTemp
        let todaysLow = today.lowTemp
        HighLabel.text = "\(String(describing: todaysHigh))"
        LowLabel.text = "\(String(describing: todaysLow))"
        
    
        
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
        print("Swiped")
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
    
    
    
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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



