//
//  ForecastDetailViewController.swift
//  WeatherTheStorm
//
//  Created by Sean Jones on 4/29/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class ForecastDetailViewController: UIViewController {
    //MARK: PROPERTIES
    
    var date: Date = Date()
    var location: Location?
    var userIsMale: Bool?
    var userName: String = ""
    var userCity: String = ""
    
   
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var pinImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var middleContainer: UIView!
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var dailyForecastTableView: UITableView!
    @IBOutlet weak var hourlyForecastCollectionView: UICollectionView!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var precipLabel: UILabel!
    @IBOutlet weak var PressureLabel: UILabel!
    @IBOutlet weak var VisibilityLabel: UILabel!
    @IBOutlet weak var UVLabel: UILabel!
    @IBOutlet weak var AQILabel: UILabel!
    @IBOutlet weak var airLabel: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopContainer()
        setupMiddleContainer()
        unwrapForecasts()
        dailyForecastTableView.delegate = self
        dailyForecastTableView.dataSource = self
        hourlyForecastCollectionView.delegate = self
        hourlyForecastCollectionView.dataSource = self
        setupDateLabel()
        makeEdgesRound()
        setupWeatherLabels()
        
        hourlyForecastCollectionView.register(HourlyForecastDetailCollectionViewCell.self, forCellWithReuseIdentifier: "hourlyDetailCell")
        
    }
    
    
    func setupWeatherLabels(){
        guard let weatherToday = location?.weather?.current  else {return}
        
        
        let humidity = String(weatherToday.humidity)
        let precip = String(weatherToday.precipitationAmount)
        let pressure = String(weatherToday.pressure)
        let UVIndex = String(weatherToday.uvIndex)
        let visibility = String(weatherToday.visibility)
         
        humidityLabel.text = "\(humidity)%"
        precipLabel.text = "\(precip) in"
        PressureLabel.text = "\(pressure) inHg"
        UVLabel.text = "\(UVIndex)"
        VisibilityLabel.text = "\(visibility) mi"
        
        
        guard let wind = weatherToday.windDirection else {return}
        windLabel.text = "\(wind) mph"
        
        guard let AQI = location?.weather?.airQualityIndex else {return}
        AQILabel.text = "\(AQI)"
        
     
    }
    
    func makeEdgesRound() {
        dailyForecastTableView.layer.cornerRadius = 5
        dailyForecastTableView.clipsToBounds = true
        hourlyForecastCollectionView.layer.cornerRadius = 5
        hourlyForecastCollectionView.clipsToBounds = true
        
    }
    
    func setupDateLabel() {
        dateLabel.text = self.date.formatDate()
        dateLabel.textColor = .white
        
    }
    
    func setupTopContainer() {
        setGradientBackground()
    }
    
    func setGradientBackground() {
        
        let  gradientLayer = CAGradientLayer()
        gradientLayer.frame = topContainer.bounds
        gradientLayer.colors = [UIColor(named: "HomeControllerTopBG")?.cgColor ?? UIColor.blue.cgColor, UIColor(named: "HomeControllerBottBG")?.cgColor ?? UIColor.cyan]
        topContainer.layer.insertSublayer(gradientLayer, at: 0)
        
        
    }
    
    func setupMiddleContainer() {
        middleContainer.backgroundColor = UIColor(named: "HomeControllerBottBG")
        middleContainer.layer.cornerRadius = 5
        middleContainer.clipsToBounds = true
    }
    func unwrapForecasts() {
        guard let hourlyweather = self.location?.weather?.hourlyForecasts,
            let dailyforecasts = self.location?.weather?.dailyForecasts,
            let currentWeather = self.location?.weather?.current,
            let cityName = self.location?.city
            else {return}
        
        setupCityName(cityName: cityName)
        setupCurrentWeather(currentWeather: currentWeather)
        setupDailyWeather(dailyforecasts: dailyforecasts)
        
        
        
    }
    
    func setupCityName(cityName: String) {
        cityLabel.text = cityName
        cityLabel.textColor = .white
        
    }
    
    func setupCurrentWeather(currentWeather: Current){
        guard let phrase = currentWeather.phrase else {return}
        phraseLabel.text = "Hello, \(userName)! It's a \(phrase) day in \(self.userCity)"
        phraseLabel.textColor = .white
        let currentTemp = String(currentWeather.temperature)
        tempLabel.text = "\(currentTemp)º"
        tempLabel.textColor = .white
        feelsLikeLabel.text = "Feels Like \(currentWeather.feelsLike)"
        feelsLikeLabel.textColor = .white
        
    }
    
    func setupDailyWeather(dailyforecasts: NSOrderedSet) {
        guard let today = dailyforecasts.firstObject as? DailyForecast, today.maxTemp != 0, today.lowTemp != 0 else {
            highLabel.isHidden = true
            lowLabel.isHidden = true
            return
        }
        
        let hi = String(today.maxTemp)
        let lo = String(today.lowTemp)
        
        highLabel.text = "\(hi)º"
        highLabel.textColor = .white
        lowLabel.text = "\(lo)º"
        lowLabel.textColor = .white
        
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

extension ForecastDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dailiesCount = self.location?.weather?.dailyForecasts?.count else {return 0}
        return dailiesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  dailyForecastTableView.dequeueReusableCell(withIdentifier: "homeDailyCell", for: indexPath) as? HomeDailyForecastTableViewCell, let dailyWeather = self.location?.weather?.dailyForecasts?.object(at: indexPath.row) as? DailyForecast else {return UITableViewCell()}
        
        let day =  dailyWeather.dow
        let high = dailyWeather.maxTemp
        let low = dailyWeather.lowTemp
        
        if high != 0 {
            
            let highTemp = String(high)
            cell.HiLabel.text = "\(highTemp)º"
            cell.HiLabel.textColor = UIColor(named: "HighOrange")
            
        }
        
        if low != 0 {
            let lowTemp = String(low)
            cell.loLabel.text = "\(lowTemp)º"
            cell.loLabel.textColor = UIColor(named: "LowBlue")
        }
        
        cell.dayLabel.text = day
        
        
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "10-Day Forecast"
    }
    
    
    
}

extension ForecastDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let hourliesCount = self.location?.weather?.hourlyForecasts?.count else {return 0}
        return hourliesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyDetailCell", for: indexPath) as? HourlyForecastDetailCollectionViewCell,
            let hourlyForecast = self.location?.weather?.hourlyForecasts?.object(at: indexPath.row) as? HourlyForecast else {return UICollectionViewCell()}
        
        
        
        let time = hourlyForecast.time
        let temp = String(hourlyForecast.temp)
        
        cell.timeLabel?.text = time
        cell.tempLabel?.text = temp
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.height
        let layout = hourlyForecastCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        return layout.itemSize
    }
    
    
}

extension ForecastDetailViewController: UIScrollViewDelegate {
    
}




