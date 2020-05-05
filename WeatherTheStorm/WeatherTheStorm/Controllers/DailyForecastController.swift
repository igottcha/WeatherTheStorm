//
//  DailyForecastController.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 4/28/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation

class DailyForecastController {
    
    static func fetchForecast(location: Location, coordinate: CLLocationCoordinate2D, firstDate: Date, secondDate: Date, completion: @escaping () -> Void) {
        guard let apiURL = NetworkController.buildForecastURL(coordinate: coordinate, firstDate: firstDate, secondDate: secondDate, isDaily: true) else { return }
        NetworkController.genericAPICall(url: apiURL, type: DailyTopLevelObject.self) { (result) in
            switch result {
            case .success(let topLevelOjbect):
                let forecasts = topLevelOjbect.forecasts
                location.weather?.dailyForecasts = forecasts
            case .failure(let error):
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
            }
        }
    }
}