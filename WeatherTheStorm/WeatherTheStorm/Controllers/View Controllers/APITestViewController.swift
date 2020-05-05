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
    
    //MARK: - Outlets
    
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var hourlyForecastButton: UIButton!
    @IBOutlet weak var dailyForecastButton: UIButton!
    @IBOutlet weak var forecastTableView: UITableView!
    @IBOutlet weak var airQualityIndexLabel: UILabel!
    
    @IBOutlet weak var aipIndexLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var hourlyTempLabel: UILabel!
    
    //MARK: - Test Properties
    
    let searchTerm = "lehi"
    let startDate = Date()
    var dateComponent = DateComponents()
    var endDate: Date {
        dateComponent.day = 3
        return Calendar.current.date(byAdding: dateComponent, to: startDate) ?? Date()
    }
    var location: Location?
    var currentWeather: CurrentWeather?
    
    //MARK: - Properties
    
    var trip: Trip?
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hourlyForecastButton.isSelected = true
        hourlyForecastButton.layer.cornerRadius = 10
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        updateViews()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        forecastTableView.reloadData()
    }
    
    //MARK: - Actions
    
    @IBAction func hourlyForecastButtonTapped(_ sender: UIButton) {
        hourlyForecastButton.isSelected = true
        hourlyForecastButton.imageView?.backgroundColor = .systemTeal
        dailyForecastButton.imageView?.backgroundColor = .white
        
    }
    @IBAction func dailyForecastButtonTapped(_ sender: UIButton) {
        hourlyForecastButton.isSelected = false
        dailyForecastButton.imageView?.backgroundColor = .systemTeal
        hourlyForecastButton.imageView?.backgroundColor = .white
    }
    
    //MARK: - Methods
    
    func fetchCurrentWeather() {
        LocationController.getPlacemark(searchTerm: searchTerm) { (result) in
            switch result {
            case .success(let placemark):
                self.location = Location(destination: placemark, weather: nil)
                guard let location = self.location, let coordinate = location.destination?.location?.coordinate else { return }
                CurrentWeatherController.fetchForecast(location: location, coordinate: coordinate) { (result) in
                    switch result {
                    case .success(_):
                        guard let weather = location.weather else { return }
                        DispatchQueue.main.async {
                            self.currentWeatherLabel.text = "Currently it feels like \(weather.current.feelsLike)°"
                            print(weather)
                        }
                    case .failure(let error):
                        print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
                    }
                }
            case .failure(let error):
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
            }
        }
    }
    
    func fetchDailyForecast() {
        LocationController.getPlacemark(searchTerm: searchTerm) { (result) in
            switch result {
            case .success(let placemark):
                self.location = Location(destination: placemark, weather: nil)
                guard let location = self.location, let coordinate = location.destination?.location?.coordinate else { return }
                DailyForecastController.fetchForecast(location: location, coordinate: coordinate, firstDate: self.startDate, secondDate: self.endDate) {
                    self.forecastTableView.reloadData()
                    print(location)
                }
            case .failure(let error):
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
            }
        }
    }
    
    func fetchHourlyForecast() {
        LocationController.getPlacemark(searchTerm: searchTerm) { (result) in
            switch result {
            case .success(let placemark):
                self.location = Location(destination: placemark, weather: nil)
                guard let location = self.location, let coordinate = location.destination?.location?.coordinate else { return }
                HourlyWeatherController.fetchForecast(location: location, coordinate: coordinate, firstDate: self.startDate, secondDate: self.endDate) {
                    self.forecastTableView.reloadData()
                    print(location)
                }
            case .failure(let error):
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
            }
        }
    }
    
    func fetchAQI() {
        LocationController.getPlacemark(searchTerm: searchTerm) { (result) in
            switch result {
            case .success(let placemark):
                self.location = Location(destination: placemark, weather: nil)
                guard let location = self.location, let coordinate = location.destination?.location?.coordinate else { return }
                AirQualityController.shared.fetchAQI(location: location, coordinate: coordinate) { (result) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(_):
                            guard let weather = location.weather else { return }
                            self.airQualityIndexLabel.text = "Air Quality Index: \(weather.airQuality.index)"
                            print(weather)
                        case .failure(let error):
                            print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
                        }
                    }
                }
            case .failure(let error):
                print("Error with \(#function) : \(error.localizedDescription) : --> \(error)")
            }
        }
    }
    
    //MARK: - Methods
    
    func updateViews() {
        fetchCurrentWeather()
        fetchDailyForecast()
        fetchHourlyForecast()
        fetchAQI()
    }
}

extension APITestViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let weather = location?.weather else { return 0 }
        return hourlyForecastButton.isSelected ? weather.hourlyForecasts.count : weather.dailyForecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath)
        
        guard let weather = location?.weather else { return UITableViewCell() }
        
        if hourlyForecastButton.isSelected {
            let hourly = weather.hourlyForecasts[indexPath.row]
            cell.textLabel?.text = hourly.time
            cell.detailTextLabel?.text = String(hourly.temp)
        } else {
            let daily = weather.dailyForecasts[indexPath.row]
            cell.textLabel?.text = daily.dow
            cell.detailTextLabel?.text = "\(String(describing: daily.maxTemp))"
        }
        
        return cell
    }
    
    
    
    
}
