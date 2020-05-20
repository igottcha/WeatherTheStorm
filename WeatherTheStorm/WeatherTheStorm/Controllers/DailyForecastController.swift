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
    
    static func fetchForecast(location: Location, firstDate: Date, secondDate: Date, completion: @escaping (Result<DailyTopLevelObject, GenericError>) -> Void) {
        guard let latitude = location.latitude, let longitude = location.longitude, let apiURL = NetworkController.buildForecastURL(latitude: latitude, longitude: longitude, firstDate: firstDate, secondDate: secondDate, isDaily: true) else { return }
        NetworkController.genericAPICall(url: apiURL, type: DailyTopLevelObject.self) { (result) in
            switch result {
            case .success(let topLevelOjbect):
                let forecasts = topLevelOjbect.forecasts.map { (forecast: DailyWeatherForecast) -> DailyForecast in
                    let day = forecast.day ?? nil
                    let lowTemp = forecast.lowTemp ?? 0
                    let maxTemp = forecast.maxTemp ?? 0
                    let chanceOfPrecipitation = day?.chanceOfPrecipitation ?? 0
                    let cloudCoverPercentage = day?.cloudCoverPercentage ?? 0
                    let iconCode = day?.iconCode ?? 0
                    return DailyForecast(date: forecast.date.stringToDate(),lowTemp: Int64(lowTemp), maxTemp: Int64(maxTemp), dow: forecast.dow, chanceOfPrecipitation: Int64(chanceOfPrecipitation), cloudCoverPercentage: Int64(cloudCoverPercentage), precipitationType: day?.precipitationType, shortPhrase: day?.shortPhrase, iconCode: Int64(iconCode))
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
