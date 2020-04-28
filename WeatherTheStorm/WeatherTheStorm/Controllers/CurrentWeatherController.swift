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
    
    static func fetchForecast(coordinate: CLLocationCoordinate2D, completion: @escaping (Result<CurrentWeather, GenericError>) -> Void) {
        guard let baseURL = baseURL else { completion(.failure(.invalidURL)); return }
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: "geocode", value: "\(coordinate.latitude)%2C\(coordinate.longitude)"),
                                    URLQueryItem(name: "units", value: unitValue),
                                    URLQueryItem(name: "language", value: language),
                                    URLQueryItem(name: "format", value: "json"),
                                    URLQueryItem(name: "apiKey", value: apiKeyValue)]
        
        guard let finalURL = urlComponents?.url else { completion(.failure(.invalidURL)); return }
        print(finalURL)
        
        NetworkController.genericAPICall(url: finalURL, type: CurrentWeather.self) { (result) in
            switch result {
            case .success(let currentWeatherForecast):
                guard let currentWeather = currentWeatherForecast.first else { completion(.failure(.unableToDecode)); return }
                completion(.success(currentWeather))
            case .failure(let error):
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
            }
        }
    }
}
