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
            let feelsLike =  trip?.location?.weather?.current?.feelsLike else { return }
        recommendationsLabel.text = "We recommend bringing the following items for your trip: Rain jacket, rain boots, umbrella"
        weatherForecastLabel.text = "Your trip to \(location) is coming up. The weather is currently \(currentTemp) degrees. It feels like \(feelsLike) degrees. Be sure to bring x, y, z."
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
