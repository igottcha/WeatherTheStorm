//
//  CurrentWeatherController.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 4/28/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation

class CurrentWeatherController {
    
    private static let baseURL = URL(string: "https://api.weather.com/v3/wx/observations/current")
    private static let apiKeyValue = "320c9252a6e642f38c9252a6e682f3c6"
    private static var unitValue = "e"
    private static let language = "en-US"
    
    static func fetchForecast(location: Location,  completion: @escaping (Result<CurrentWeather, GenericError>) -> Void) {
        guard let baseURL = baseURL else { completion(.failure(.invalidURL)); return }
        guard let coordinate = location.destination?.location?.coordinate else {return}
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: "geocode", value: "\(coordinate.latitude),\(coordinate.longitude)"),
                                    URLQueryItem(name: "units", value: unitValue),
                                    URLQueryItem(name: "language", value: language),
                                    URLQueryItem(name: "format", value: "json"),
                                    URLQueryItem(name: "apiKey", value: apiKeyValue)]
        
        guard let finalURL = urlComponents?.url else { completion(.failure(.invalidURL)); return }
        print(finalURL)
        
        NetworkController.genericAPICall(url: finalURL, type: CurrentWeather.self) { (result) in
            switch result {
            case .success(let currentWeather):
                //location.weather?.current = currentWeather
                let current = Current(pressure: currentWeather.pressure, feelsLike: Int64(currentWeather.feelsLike), humidity: Int64(currentWeather.humidity), phrase: currentWeather.phrase, precipitationAmount: currentWeather.precipitationAmount, temperature: Int64(currentWeather.temperature), uvIndex: Int64(currentWeather.uvIndex), visibility: Int64(currentWeather.visibility), windSpeed: Int64(currentWeather.windSpeed), windDirection: currentWeather.windDirection)
                location.weather?.current = current
                completion(.success(currentWeather))
                return
            case .failure(let error):
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
            }
        }
    }
}
