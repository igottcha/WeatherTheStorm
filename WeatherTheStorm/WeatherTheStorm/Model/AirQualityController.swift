//
//  AirQualityController.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/1/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation

class AirQualityController {
    
    static let shared = AirQualityController()

    
    private let apiKey = "be597a5a-bfb7-412d-8b98-033a96e0e2cf"
    private let baseURL = URL(string: "https://api.airvisual.com/v2/nearest_city")
    
    func fetchAQI(location: Location, coordinate: CLLocationCoordinate2D, completion: @escaping (Result<AirQuality, GenericError>) -> Void) {
        guard let baseURL = baseURL else { completion(.failure(.invalidURL)); return }
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: "lat", value: String(coordinate.latitude)),
                                    URLQueryItem(name: "lon", value: String(coordinate.longitude)),
                                    URLQueryItem(name: "key", value: apiKey)]
        guard let finalURL = urlComponents?.url else { completion(.failure(.invalidURL)); return }
        print(finalURL)
        
        NetworkController.genericAPICall(url: finalURL, type: AQITopLevelObject.self) { (result) in
            switch result {
            case .success(let topLevelObject):
                let airQuality = topLevelObject.data.current.pollution
                location.weather?.airQuality = airQuality
                completion(.success(airQuality))
                return
            case .failure(let error):
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
            }
        }
    }
    
}
