//
//  TripsTableViewCell.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 5/8/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class TripsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - Outlets
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var dailyForecastCollectionView: UICollectionView!
    
    //MARK: - Properties
    
    var trip: Trip? {
        didSet {
            guard let trip = trip ,
                let city = trip.location?.destination?.locality,
                let state = trip.location?.destination?.administrativeArea,
                let country = trip.location?.destination?.country,
                let startDate = trip.startDate,
                let endDate = trip.endDate else { return }
            
            locationLabel.text =  "\(city), \(state), \(country)"
            datesLabel.text = "\(startDate.formatDate()) - \(endDate.formatDate())"
            dailyForecastCollectionView.delegate = self
            dailyForecastCollectionView.dataSource = self
            
        }
    }
    
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
                    self.dailyForecastCollectionView.reloadData()
                }
            case .failure(let error):
                print(error, error.localizedDescription)
            }
            
        }
        
        HourlyWeatherController.fetchForecast(location: location) { _ in
            
        }
        
        CurrentWeatherController.fetchForecast(location: location, coordinate: coordinate) { (result) in
            switch result {
            case .success(let currentWeather):
                print(currentWeather)
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
        guard let cell = dailyForecastCollectionView.dequeueReusableCell(withReuseIdentifier: "dailyForecastCell", for: indexPath) as? DailyForecastCollectionViewCell else { return UICollectionViewCell() }
        guard let weather = trip?.location?.weather?.dailyForecasts else { return UICollectionViewCell() }
        let daily = weather[indexPath.row]
        
        guard let lowTemp = daily.lowTemp,
        let highTemp = daily.maxTemp else { return UICollectionViewCell() }
        
        cell.temperaturesLabel.text = "\(lowTemp) - \(highTemp)"
        //cell.weatherImageView.image = "some image"
        cell.forecastDateLabel.text = daily.dow
        
        
        return cell
    }
    
    
}
