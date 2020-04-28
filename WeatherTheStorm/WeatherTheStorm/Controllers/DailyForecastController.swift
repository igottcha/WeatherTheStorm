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
    
    static let shared = DailyForecastController()
    var forecast: [DailyForecast] = []
    
    func fetchForecast(coordinate: CLLocationCoordinate2D, firstDate: Date, secondDate: Date) {
       guard let apiURL = NetworkController.buildForecastURL(coordinate: coordinate, firstDate: firstDate, secondDate: secondDate, isDaily: true) else { return }
        NetworkController.genericAPICall(url: apiURL, type: DailyForecast.self) { (result) in
            switch result {
            case .success(let forecast):
                self.forecast = forecast
            case .failure(let error):
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
            }
        }
    }
}
