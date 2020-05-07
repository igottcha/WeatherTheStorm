//
//  DailyForecastCollectionViewCell.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 5/5/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit
import CoreLocation

class DailyForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherStatusImage: UIImageView!
    @IBOutlet weak var currentTempLabel: UILabel!
    
    func getWeather(for trip: Trip) {
           guard let location = trip.location,
               let coordinate = location.destination?.location?.coordinate,
               let startDate = trip.startDate,
               let endDate = trip.endDate else { return }
           
           DailyForecastController.fetchForecast(location: location, coordinate: coordinate, firstDate: startDate, secondDate: endDate) {
               
           }
           HourlyWeatherController.fetchForecast(location: location, coordinate: coordinate, firstDate: startDate, secondDate: endDate) {
               
           }
           CurrentWeatherController.fetchForecast(location: location, coordinate: coordinate) { (result) in
               switch result {
               case .success(let currentWeather):
                   print(currentWeather)
                   self.currentTempLabel.text = "\(currentWeather)"
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
    
    
}
