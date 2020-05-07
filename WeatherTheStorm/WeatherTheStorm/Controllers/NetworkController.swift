//
//  NetworkController.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 4/28/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation

enum GenericError: LocalizedError {
    
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Unable to reach server"
        case .thrownError(let error):
            return "Error with \(#function) : \(error.localizedDescription) : --> \(error)"
        case .noData:
            return "The server responded with no data"
        case .unableToDecode:
            return "The server responded with bad data"
        }
    }
}

class NetworkController {
    
    private static let baseForecastURL = URL(string: "https://api.weather.com/v1/geocode")
    private static let apiKeyValue = "320c9252a6e642f38c9252a6e682f3c6"
    private static var unitValue = "e"
    private static let language = "en-US"
    
    static func buildForecastURL(coordinate: CLLocationCoordinate2D, firstDate: Date?, secondDate: Date?, isDaily: Bool) -> URL? {
        
        guard let baseURL = baseForecastURL else { return nil }
        
        var newBaseURL = baseURL.appendingPathComponent(String(coordinate.latitude)).appendingPathComponent(String(coordinate.longitude))
            .appendingPathComponent("forecast")
            
        if isDaily {
            guard let firstDate = firstDate,
                let secondDate = secondDate else {return nil}
            let numOfDays = TripController.calcNumOfDays(between: firstDate, and: secondDate)
            newBaseURL.appendPathComponent("daily")
            newBaseURL.appendPathComponent("\(numOfDays)day")
        } else {
            newBaseURL.appendPathComponent("hourly")
            newBaseURL.appendPathComponent("48hour")
        }
        
        newBaseURL.appendPathExtension("json")
        
        var urlComponents = URLComponents(url: newBaseURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: "units", value: unitValue),
                                     URLQueryItem(name: "language", value: "en-US"),
                                     URLQueryItem(name: "apiKey", value: apiKeyValue)]
    
        guard let finalURL = urlComponents?.url else { return nil }
        print(finalURL)
        return finalURL
    }
    
    static func genericAPICall<T: Codable> (url: URL, type: T.Type, completion: @escaping (Result<T, GenericError>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
                completion(.failure(.thrownError(error)))
                return
            }
            
            guard let data = data else { completion(.failure(.noData)); return }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
                completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
}
