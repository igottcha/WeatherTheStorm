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
    
    //MARK: - Test Properties
    
    let searchTerm = "lehi"
    let startDate = Date()
    var dateComponent = DateComponents()
    var endDate: Date {
        dateComponent.day = 3
        return Calendar.current.date(byAdding: dateComponent, to: startDate) ?? Date()
    }
    var coordinate: CLLocationCoordinate2D?
    var currentWeather: CurrentWeather?
    
    //MARK: - Properties
    
    
    
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
                self.coordinate = placemark.location?.coordinate
                guard let coordinate = self.coordinate else { return }
                CurrentWeatherController.fetchForecast(coordinate: coordinate) { (result) in
                    switch result {
                    case .success(let currentWeather):
                        DispatchQueue.main.async {
                            self.currentWeatherLabel.text = "Currently it feels like \(currentWeather.feelsLike)°"
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
                self.coordinate = placemark.location?.coordinate
                guard let coordinate = self.coordinate else { return }
                DailyForecastController.shared.fetchForecast(coordinate: coordinate, firstDate: self.startDate, secondDate: self.endDate) {
                    self.forecastTableView.reloadData()
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
                self.coordinate = placemark.location?.coordinate
                guard let coordinate = self.coordinate else { return }
                HourlyWeatherController.shared.fetchForecast(coordinate: coordinate, firstDate: self.startDate, secondDate: self.endDate) {
                    self.forecastTableView.reloadData()
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
                self.coordinate = placemark.location?.coordinate
                guard let coordinate = self.coordinate else { return }
                AirQualityController.shared.fetchAQI(coordinate: coordinate) { (result) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let airQuality):
                            self.airQualityIndexLabel.text = "Air Quality Index: \(airQuality.index)"
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
        hourlyForecastButton.isSelected ? HourlyWeatherController.shared.forecasts.count : DailyForecastController.shared.forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath)
        
        if hourlyForecastButton.isSelected {
            let hourly = HourlyWeatherController.shared.forecasts[indexPath.row]
            cell.textLabel?.text = hourly.time
            cell.detailTextLabel?.text = String(hourly.temp)
        } else {
            let daily = DailyForecastController.shared.forecasts[indexPath.row]
            cell.textLabel?.text = daily.dow
            cell.detailTextLabel?.text = "\(daily.maxTemp)"
        }
        
        return cell
    }
    
    
    
    
}
