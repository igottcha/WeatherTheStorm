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
    
    //MARK:- OUTLETS
    @IBOutlet weak var gear: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var phraseLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    
    @IBOutlet weak var feelsLikeLAbel: UILabel!
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var middleContainer: UIView!
    @IBOutlet weak var dailyForecastTableView: UITableView!
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopContainer()
        setupMiddleContainer()
        unwrapForecasts()
        dailyForecastTableView.delegate = self
        dailyForecastTableView.dataSource = self
        setupDateLabel()
        
        
        
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
            let cityName = self.location?.destination?.locality
            else {return}
        
        setupCityName(cityName: cityName)
        setupCurrentWeather(currentWeather: currentWeather)
        setupDailyWeather(dailyforecasts: dailyforecasts)
        
        
        
    }
    
    func setupCityName(cityName: String) {
        cityLabel.text = cityName
        cityLabel.textColor = .white
        
    }
    
    func setupCurrentWeather(currentWeather: CurrentWeather){
        let phrase = currentWeather.phrase
        phraseLabel.text = "Hello, \(userName)! It's a \(phrase) day in \(self.userCity)"
        phraseLabel.textColor = .white
        let currentTemp = String(currentWeather.temperature)
        tempLabel.text = "\(currentTemp)º"
        tempLabel.textColor = .white
        feelsLikeLAbel.text = "feels Like \(currentWeather.feelsLike)"
        feelsLikeLAbel.textColor = .white
        
    }
    
    func setupDailyWeather(dailyforecasts: [DailyForecast]){
        let today = dailyforecasts[0]
        guard let hiToday = today.maxTemp,
            let loToday = today.lowTemp else {
                highLabel.isHidden = true
                lowLabel.isHidden = true
                return
        }
        
        var hi = String(hiToday)
        var lo = String(loToday)
        
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
        guard let cell =  dailyForecastTableView.dequeueReusableCell(withIdentifier: "homeDailyCell", for: indexPath) as? HomeDailyForecastTableViewCell else {return UITableViewCell()}
        guard let dailyWeather = self.location?.weather?.dailyForecasts?[indexPath.row] else {return cell}
        
        let day =  dailyWeather.dow
        if let high = dailyWeather.maxTemp {
            
            let highTemp = String(high)
            cell.HiLabel.text = "\(highTemp)º"
            cell.HiLabel.textColor = UIColor(named: "HighOrange")
            
            
        }
        
        if let low = dailyWeather.lowTemp {
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




