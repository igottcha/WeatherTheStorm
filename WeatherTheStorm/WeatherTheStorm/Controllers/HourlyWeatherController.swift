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
        guard let coordinate = location.destination?.location?.coordinate else {return}
        guard let apiURL = NetworkController.buildForecastURL(coordinate: coordinate, firstDate: nil, secondDate: nil, isDaily: false) else { return }
        NetworkController.genericAPICall(url: apiURL, type: HourlyTopLevelObject.self) { (result) in
            switch result {
            case .success(let topLevelObject):
                let forecasts = topLevelObject.forecasts
                if (location.weather != nil)  {
                    location.weather?.hourlyForecasts = forecasts
                } else {
                    location.weather = Weather(current: nil, hourlyForecasts: forecasts, dailyForecasts: nil, airQuality: nil)
                }
            case .failure(let error):
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
            }
            completion(result)
        }
    }
    
}
