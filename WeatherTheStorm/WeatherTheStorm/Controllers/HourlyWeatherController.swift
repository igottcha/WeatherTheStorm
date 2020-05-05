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
    
    static func fetchForecast(location: Location, coordinate: CLLocationCoordinate2D, firstDate: Date, secondDate: Date, completion: @escaping () -> Void) {
        guard let apiURL = NetworkController.buildForecastURL(coordinate: coordinate, firstDate: firstDate, secondDate: secondDate, isDaily: false) else { return }
        NetworkController.genericAPICall(url: apiURL, type: HourlyTopLevelObject.self) { (result) in
            switch result {
            case .success(let topLevelObject):
                let forecasts = topLevelObject.forecasts
                location.weather?.hourlyForecasts = forecasts
            case .failure(let error):
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
            }
        }
    }
    
}
