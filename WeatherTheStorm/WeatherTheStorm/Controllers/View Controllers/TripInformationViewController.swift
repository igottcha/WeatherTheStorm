//
//  TripInformationViewController.swift
//  WeatherTheStorm
//
//  Created by Hin Wong on 5/12/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

class TripInformationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - Outlets
    
    @IBOutlet weak var weatherForecastLabel: UILabel!
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    @IBOutlet weak var recommendationsLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forecastCollectionView.delegate = self
        forecastCollectionView.dataSource = self
        forecastCollectionView.layer.cornerRadius = 7
        guard let trip = trip else { return }
        getWeather(for: trip)
        updateViews()
        //setUpRecommendations()
        //setUpWeatherImageView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        forecastCollectionView.reloadData()
    }
    
    //MARK: - Properties
    
    var trip: Trip?
    
    //MARK: - View functions
    
    func updateViews() {
        guard let city = trip?.location?.city,
            let currentTemp = trip?.location?.weather?.current?.temperature,
            let feelsLike =  trip?.location?.weather?.current?.feelsLike,
            let phrase = trip?.location?.weather?.current?.phrase,
            let state = trip?.location?.state else { return }
        
        weatherForecastLabel.text = "Your trip to \(city), \(state) is coming up, and it is looking \(phrase). The weather is currently \(currentTemp) ºF, and feels like \(feelsLike) ºF. Have a nice trip!"        
    }
    
    func setUpRecommendations() {
        guard let temp = trip?.location?.weather?.current?.temperature else { return }
        switch temp {
        case 90..<1000:
            recommendationsLabel.text = "~ Short sleeves\n shorts\n airy clothing\n Stay hydrated!"
        case 80...89:
            recommendationsLabel.text = "We recommend that you bring the folowing: Short sleeves, shorts, and airy clothes."
        case 70...79:
            recommendationsLabel.text = "We recommend that you bring the following: Short sleeves, breathable fabrics, shorts."
        case 60...69:
            recommendationsLabel.text = "\n ~ Long pants\n\n ~ Long sleeves\n\n ~ Light sweater\n\t or jacket"
        case 50...59:
            recommendationsLabel.text = "It's sweater weather! Wear pants and a light jacket."
        case 40...49:
            recommendationsLabel.text = "It's a bit chilly out today. Wear a warm jacket and long pants."
        case 30...39:
            recommendationsLabel.text = "It's pretty chilly today. Best wear a winter coat, hat, and gloves."
        case -1000...29:
            recommendationsLabel.text = "It's a cold one out there! Bundle up with a winter coat, scarf, hat, and gloves. Bonus for wooly socks."
        default:
            recommendationsLabel.text = "Cannot get temperature data to make recommendations."
        }
    }
    
    func setUpWeatherImageView() {
        let gender = UserController.shared.isMale
        guard let feelsLikeTemp = trip?.location?.weather?.current?.feelsLike else { return }
        
        if gender == false && feelsLikeTemp >= 90 {
            weatherImageView.image = UIImage(named: "female_cloudy_shortsshirtsunglassescap") // f
        }
        else if gender == true && feelsLikeTemp >= 90{
            weatherImageView.image = UIImage(named: "Male_Cloudy_shortsshirt") //m
        }
        else if gender == false && 70...89 ~= feelsLikeTemp {
            weatherImageView.image = UIImage(named: "female_partlycloudy_shortsshirt") // f
        }
        else if gender == true && 70...89 ~= feelsLikeTemp {
            weatherImageView.image = UIImage(named: "Male_Partlycloudy_shortsshirt") // m
        }
        else if gender == true && 70...89 ~= feelsLikeTemp {
            weatherImageView.image = UIImage(named: "Male_Cloudy_shortsshirt") //m
        }
        else if gender == true && 60...69 ~= feelsLikeTemp {
            weatherImageView.image = UIImage(named: "Male_Partlycloudy_pantscoat") //m
        }
        else if gender == false && 60...69 ~= feelsLikeTemp {
            weatherImageView.image = UIImage(named: "female_partlycloudy_pantscoat") //f
        }
        else if gender == true && 40...59 ~= feelsLikeTemp {
            weatherImageView.image = UIImage(named: "Male_Clearday_pantscoat") //m
        }
        else if gender == false && 40...59 ~= feelsLikeTemp {
            weatherImageView.image = UIImage(named: "female_clearday_pantscoat")
        }
        else if gender == true && -1000...39 ~= feelsLikeTemp {
            weatherImageView.image = UIImage(named: "Male_Clearday_bootscoatglovesscarfhat") //m
        }
        else if gender == false && -1000...39 ~= feelsLikeTemp {
            weatherImageView.image = UIImage(named: "female_clearday_bootscoatglovesscarfhat") //f
        }
        else {
            weatherImageView.image = UIImage(named: "female_clearday_pantscoat")
        }
        
    }
    
    
    //MARK: - Weather Info Methods
    
    func getWeather(for trip: Trip) {
        guard let location = trip.location,
            let startDate = trip.startDate,
            let endDate = trip.endDate else { return }
        
        DailyForecastController.fetchForecast(location: location, firstDate: startDate, secondDate: endDate) { (result) in
            switch result {
            case .success(let dailyForecast):
                print(dailyForecast)
                DispatchQueue.main.async {
                    self.forecastCollectionView.reloadData()
                    
                }
            case .failure(let error):
                print(error, error.localizedDescription)
            }
            
        }
        HourlyWeatherController.fetchForecast(location: location) { _ in
            
        }
        CurrentWeatherController.fetchForecast(location: location) { (result) in
            switch result {
            case .success(let currentWeather):
                print(currentWeather)
                DispatchQueue.main.async {
                    self.updateViews()
                    self.setUpRecommendations()
                    self.setUpWeatherImageView()
                }
                
            case .failure(let error):
                print(error, error.localizedDescription)
            }
        }
        AirQualityController.shared.fetchAQI(location: location) { (result) in
            switch result {
            case .success(let airQuality):
                print(airQuality)
            case .failure(let error):
                print(error, error.localizedDescription)
            }
        }
    }
    
    
    //MARK: - Collection View Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dailyForecastsCount = trip?.location?.weather?.dailyForecasts?.count else { return 0 }
        return dailyForecastsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = forecastCollectionView.dequeueReusableCell(withReuseIdentifier: "forecastCell", for: indexPath) as? ForecastCollectionViewCell, let daily = trip?.location?.weather?.dailyForecasts?.object(at: indexPath.row) as? DailyForecast, let date = daily.date else { return UICollectionViewCell() }
        
        cell.dateLabel.text = "\(date.month()) \(date.day())"
        
        cell.lowTempLabel.text = "\(daily.lowTemp)"
        cell.highTempLabel.text = "\(daily.maxTemp)"
        
        
        return cell
    }
    
}

extension TripInformationViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = forecastCollectionView.bounds.width
        let collectionHeight = forecastCollectionView.bounds.height
        
        
        return CGSize(width: collectionWidth * 0.95, height: collectionHeight * 0.10)
    }
}
