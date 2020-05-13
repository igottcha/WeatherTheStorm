//
//  TripInformationViewController.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 5/12/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class TripInformationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - Outlets
    
    @IBOutlet weak var weatherForecastLabel: UILabel!
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    @IBOutlet weak var recommendationsLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forecastCollectionView.delegate = self
        forecastCollectionView.dataSource = self
        guard let trip = trip else { return }
        getWeather(for: trip)
        updateViews()
        setUpRecommendations()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        forecastCollectionView.reloadData()
    }
    
    //MARK: - Properties
    
    var trip: Trip?
    
    //MARK: - View functions
    
    func updateViews() {
        guard let location = trip?.location?.destination?.locality,
            let currentTemp = trip?.location?.weather?.current?.temperature,
            let feelsLike =  trip?.location?.weather?.current?.feelsLike,
            let state = trip?.location?.destination?.administrativeArea else { return }
        
        weatherForecastLabel.text = "Your trip to \(location), \(state) is coming up. The weather is currently \(currentTemp) degrees. It feels like \(feelsLike) degrees. Have a nice trip!"
        
    }
    
    func setUpRecommendations() {
        guard let temp = trip?.location?.weather?.current?.temperature else { return }
        if temp >= 70 {
            recommendationsLabel.text = "We recommend bringing the following items for your trip: Short sleeves, breathable fabrics, and shorts."
        } else if temp <= 69 || temp >= 60 {
            recommendationsLabel.text = "We recommend bringing the following items for your trip: Long sleeves, light sweater or jacket, and long pants."
        } else if temp <= 59 || temp >= 50 {
            recommendationsLabel.text = "It's sweater weather! Wear pants and a light jacket."
        } else if temp <= 49 || temp >= 40 {
            recommendationsLabel.text = "It's a bit chilly out today. Wear a warm jacket and long pants."
        } else if temp <= 39 || temp >= 30 {
            recommendationsLabel.text = "It's pretty chilly today. Best wear a winter coat, hat, and gloves."
        } else if temp <= 29 {
            recommendationsLabel.text = "It's a cold one out there! Bundle up with a winter coat, scarf, hat, and gloves. Bonus for wooly socks."
        }
    }
    
    
    //MARK: - Weather Info Methods
    
    func getWeather(for trip: Trip) {
        guard let location = trip.location,
            let coordinate = location.destination?.location?.coordinate,
            let startDate = trip.startDate,
            let endDate = trip.endDate else { return }
        
        DailyForecastController.fetchForecast(location: location, coordinate: coordinate, firstDate: startDate, secondDate: endDate) { (result) in
            switch result {
            case .success(let dailyForecast):
                print(dailyForecast)
                DispatchQueue.main.async {
                    self.forecastCollectionView.reloadData()
                    
                }
            case .failure(let error):
                print(error, error.localizedDescription)
            }
            
        }
        HourlyWeatherController.fetchForecast(location: location) { _ in
            
        }
        CurrentWeatherController.fetchForecast(location: location) { (result) in
            switch result {
            case .success(let currentWeather):
                print(currentWeather)
                DispatchQueue.main.async {
                    self.updateViews()
                    self.setUpRecommendations()
                }
                
            case .failure(let error):
                print(error, error.localizedDescription)
            }
        }
        AirQualityController.shared.fetchAQI(location: location, coordinate: coordinate) { (result) in
            switch result {
            case .success(let airQuality):
                print(airQuality)
            case .failure(let error):
                print(error, error.localizedDescription)
            }
        }
    }
    
    
    //MARK: - Collection View Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dailyWeather = trip?.location?.weather?.dailyForecasts?.count else { return 0 }
        return dailyWeather
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = forecastCollectionView.dequeueReusableCell(withReuseIdentifier: "forecastCell", for: indexPath) as? ForecastCollectionViewCell else { return UICollectionViewCell() }
        guard let weather = trip?.location?.weather?.dailyForecasts else { return UICollectionViewCell() }
        let daily = weather[indexPath.row]
        
        cell.dateLabel.text = "\(daily.dow)"
        
        cell.lowTempLabel.text = "\(daily.lowTemp ?? 0)"
        cell.highTempLabel.text = daily.maxTemp != nil ? "\(daily.maxTemp!)" : "N/A"
        
        
        return cell
    }
   

}
