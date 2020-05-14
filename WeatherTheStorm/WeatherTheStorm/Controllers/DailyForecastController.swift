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
    
    static func fetchForecast(location: Location, coordinate: CLLocationCoordinate2D, firstDate: Date, secondDate: Date, completion: @escaping (Result<DailyTopLevelObject, GenericError>) -> Void) {
        guard let apiURL = NetworkController.buildForecastURL(coordinate: coordinate, firstDate: firstDate, secondDate: secondDate, isDaily: true) else { return }
        NetworkController.genericAPICall(url: apiURL, type: DailyTopLevelObject.self) { (result) in
            switch result {
            case .success(let topLevelOjbect):
                let forecasts = topLevelOjbect.forecasts.map { (forecast: DailyWeatherForecast) -> DailyForecast in
                    let day = forecast.day ?? nil
                    let lowTemp = forecast.lowTemp ?? 0
                    let maxTemp = forecast.maxTemp ?? 0
                    let chanceOfPrecipitation = day?.chanceOfPrecipitation ?? 0
                    let cloudCoverPercentage = day?.cloudCoverPercentage ?? 0
                    return DailyForecast(lowTemp: Int64(lowTemp), maxTemp: Int64(maxTemp), dow: forecast.dow, chanceOfPrecipitation: Int64(chanceOfPrecipitation), cloudCoverPercentage: Int64(cloudCoverPercentage), precipitationType: day?.precipitationType, shortPhrase: day?.shortPhrase)
                }
                if location.weather != nil {
                    location.weather?.dailyForecasts = NSOrderedSet(array: forecasts)
                } else {
                    location.weather = Weather(current: nil)
                    location.weather?.dailyForecasts = NSOrderedSet(array: forecasts)
                }
                completion(.success(topLevelOjbect))
            case .failure(let error):
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
                completion(.failure(error))
            }
            completion(result)
        }
    }
}
