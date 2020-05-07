//
//  TripCollectionViewCell.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 5/5/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class TripCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - Outlet
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    
    
    //MARK: - Properties
    
    var trip: Trip? {
        didSet {
            guard let trip = trip ,
                let city = trip.location?.destination?.locality,
                let state = trip.location?.destination?.administrativeArea,
                let country = trip.location?.destination?.country,
                let startDate = trip.startDate,
                let endDate = trip.endDate else { return }
            
            locationLabel.text = "Location: \(city), \(state), \(country)"
            startDateLabel.text = "Start Date: \(startDate.formatDate())"
            endDateLabel.text = "End Date: \(endDate.formatDate())"
            forecastCollectionView.delegate = self
            forecastCollectionView.dataSource = self
            
        }
    }
    
    func getWeather(for trip: Trip) {
        guard let location = trip.location,
            let coordinate = location.destination?.location?.coordinate,
            let startDate = trip.startDate,
            let endDate = trip.endDate else { return }
        
        DailyForecastController.fetchForecast(location: location, coordinate: coordinate, firstDate: startDate, secondDate: endDate) {
            
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
    
    //MARK: - Collection view methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Same issue as Sean
        guard let weather = trip?.location?.weather else {return 0}
        return weather.dailyForecasts?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = forecastCollectionView.dequeueReusableCell(withReuseIdentifier: "forecastCell", for: indexPath) as? DailyForecastCollectionViewCell else { return UICollectionViewCell() }
        guard let weather = trip?.location?.weather else { return UICollectionViewCell()}

        let weatherForecast = weather.dailyForecasts?[indexPath.row]

        //cell.currentTempLabel.text = "\(String(describing: weatherForecast.lowTemp))"
        cell.dateLabel.text = "\(String(describing: weatherForecast?.day))"
        //cell.weatherStatusImage.image = "\(someImage)"

        return cell
    }
}

// TODO: - Define the logic for different images depending on weather conditions

