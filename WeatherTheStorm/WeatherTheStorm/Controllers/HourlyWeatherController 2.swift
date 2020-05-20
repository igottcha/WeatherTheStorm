//
//  HourlyWeatherController.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 4/28/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation

class HourlyWeatherController {
    
    static func fetchForecast(location: Location, completion: @escaping (Result<HourlyTopLevelObject, GenericError>) -> Void ) {
        guard let latitude = location.latitude, let longitude = location.longitude, let apiURL = NetworkController.buildForecastURL(latitude: latitude, longitude: longitude, firstDate: nil, secondDate: nil, isDaily: false) else { return }
        NetworkController.genericAPICall(url: apiURL, type: HourlyTopLevelObject.self) { (result) in
            switch result {
            case .success(let topLevelObject):
                let forecasts = topLevelObject.forecasts.map { HourlyForecast(cloudCoverPercentage: Int64($0.cloudCoverPercentage), feelsLike: Int64($0.feelsLike), temp: Int64($0.temp), time: $0.time, shortPhrase: $0.shortPhrase) }
                
                if (location.weather != nil)  {
                    location.weather?.hourlyForecasts = NSOrderedSet(array: forecasts)
                } else {
                    location.weather = Weather(current: nil)
                    location.weather?.hourlyForecasts = NSOrderedSet(array: forecasts)
                }
            case .failure(let error):
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
            }
            completion(result)
        }
    }
    
}
