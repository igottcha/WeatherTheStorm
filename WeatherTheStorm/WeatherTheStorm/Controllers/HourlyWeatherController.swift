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
    
    static let shared = HourlyWeatherController()
    var forecast: [HourlyForecast] = []
    
    func fetchForecast(coordinate: CLLocationCoordinate2D, firstDate: Date, secondDate: Date) {
       guard let apiURL = NetworkController.buildForecastURL(coordinate: coordinate, firstDate: firstDate, secondDate: secondDate, isDaily: false) else { return }
        NetworkController.genericAPICall(url: apiURL, type: HourlyForecast.self) { (result) in
            switch result {
            case .success(let forecast):
                self.forecast = forecast
            case .failure(let error):
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
            }
        }
    }
    
}
