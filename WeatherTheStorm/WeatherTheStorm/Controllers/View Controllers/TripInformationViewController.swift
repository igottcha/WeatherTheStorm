//
//  TripInformationViewController.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 5/12/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class TripInformationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, OutfitandImage {
    
    
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
        forecastCollectionView.layer.cornerRadius = 7
        guard let trip = trip else { return }
        getWeather(for: trip)
        updateViews()
        //setUpRecommendations()
        //setUpWeatherImageView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        forecastCollectionView.reloadData()
    }
    
    //MARK: - Properties
    
    var trip: Trip?
    
    //MARK: - View functions
    
    func updateViews() {
        guard let city = trip?.location?.city,
            let currentTemp = trip?.location?.weather?.current?.temperature,
            let feelsLike =  trip?.location?.weather?.current?.feelsLike,
            let phrase = trip?.location?.weather?.current?.phrase,
            let state = trip?.location?.state else { return }
        
        weatherForecastLabel.text = "Your trip to \(city), \(state) is coming up, and it is looking \(phrase). The weather is currently \(currentTemp) °F, and feels like \(feelsLike) °F. Have a nice trip!"        
    }
    
    
    //MARK: - Weather Info Methods
    
    func getWeather(for trip: Trip) {
        guard let location = trip.location,
            let startDate = trip.startDate,
            let endDate = trip.endDate else { return }
        
        DailyForecastController.fetchForecast(location: location, firstDate: startDate, secondDate: endDate) { (result) in
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
                    self.recommendationsLabel.text = self.getClothingRecommendations(for: location)
                    self.weatherImageView.image = self.getWeatherWearAvatar(for: location)
                }
                
            case .failure(let error):
                print(error, error.localizedDescription)
            }
        }
        AirQualityController.shared.fetchAQI(location: location) { (result) in
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
        guard let dailyForecastsCount = trip?.location?.weather?.dailyForecasts?.count else { return 0 }
        return dailyForecastsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = forecastCollectionView.dequeueReusableCell(withReuseIdentifier: "forecastCell", for: indexPath) as? ForecastCollectionViewCell, let daily = trip?.location?.weather?.dailyForecasts?.object(at: indexPath.row) as? DailyForecast, let date = daily.date else { return UICollectionViewCell() }
        
        cell.dateLabel.text = "\(date.month()) \(date.day())"
        cell.conditionImageView.image = UIImage(named: "\(daily.iconCode)")
        cell.lowTempLabel.text = "\(daily.lowTemp)"
        cell.highTempLabel.text = "\(daily.maxTemp)"
        
        
        return cell
    }
    
}

extension TripInformationViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = forecastCollectionView.bounds.width
        let collectionHeight = forecastCollectionView.bounds.height
        
        
        return CGSize(width: collectionWidth * 0.95, height: collectionHeight * 0.10)
    }
}
