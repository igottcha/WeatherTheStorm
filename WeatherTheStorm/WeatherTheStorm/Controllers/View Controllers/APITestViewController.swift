//
//  APITestViewController.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 4/28/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit
import CoreLocation

class APITestViewController: UIViewController {

    //MARK: - Test Properties
    
    let searchTerm = "lehi"
    let startDate = Date()
    let endDate = Date(timeIntervalSinceNow: 7200)
    var coordinate: CLLocationCoordinate2D?
    var currentWeather: CurrentWeather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        print(DailyForecastController.shared.forecast)
        print(HourlyWeatherController.shared.forecast)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateViews()
    }
    
    func fetchCurrentWeather() {
        LocationController.getPlacemark(searchTerm: searchTerm) { (result) in
            switch result {
            case .success(let placemark):
                self.coordinate = placemark.location?.coordinate
            case .failure(let error):
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
            }
        }
        guard let coordinate = coordinate else { return }
        CurrentWeatherController.fetchForecast(coordinate: coordinate) { (result) in
            switch result {
            case .success(let currentWeather):
                self.currentWeather = currentWeather
            case .failure(let error):
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
            }
        }
    }
    
    func fetchDailyForecast() {
        LocationController.getPlacemark(searchTerm: searchTerm) { (result) in
            switch result {
            case .success(let placemark):
                self.coordinate = placemark.location?.coordinate
            case .failure(let error):
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
            }
        }
        guard let coordinate = coordinate else { return }
        DailyForecastController.shared.fetchForecast(coordinate: coordinate, firstDate: startDate, secondDate: endDate)
    }

    func fetchHourlyForecast() {
        LocationController.getPlacemark(searchTerm: searchTerm) { (result) in
            switch result {
            case .success(let placemark):
                self.coordinate = placemark.location?.coordinate
            case .failure(let error):
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
            }
        }
        guard let coordinate = coordinate else { return }
        HourlyWeatherController.shared.fetchForecast(coordinate: coordinate, firstDate: startDate, secondDate: endDate)
    }
    
    //MARK: - Methods
    
    func updateViews() {
        fetchCurrentWeather()
        fetchDailyForecast()
        fetchHourlyForecast()
    }
}
