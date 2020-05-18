//
//  Outfit+ImageController.swift
//  WeatherTheStorm
//
//  Created by Chris Gottfredson on 5/16/20.
//  Copyright © 2020 Gottfredson. All rights reserved.
//

import UIKit

protocol OutfitandImage {
    func getWeatherIcont(weather: Weather)
    func getClothingRecommendations(location: Location)
    func getWeatherWearAvatar(location: Location)
}

extension OutfitandImage {
//    func getWeatherIcon(weather: Weather) -> UIImage? {
//        guard let weather = weather.dailyForecasts else { return #imageLiteral(resourceName: "Male_Clearday_pantscoatgloveshat")}
//    }
    
    func getClothingRecommendations(location: Location) -> String {
        guard let temp = location.weather?.current?.temperature else { return ""}
        switch temp {
        case 90..<1000:
            return "We recommend that you bring/wear the following: Short sleeves, shorts, airy clothing, and stay hydrated."
        case 80...89:
            return "We recommend that you bring/wear the folowing: Short sleeves, shorts, and airy clothes."
        case 70...79:
            return "We recommend that you bring/wear the following: Short sleeves, breathable fabrics, shorts."
        case 60...69:
            return "We recommend that you bring/wear the following: Long pants, long sleeves, and a light sweater. or jacket."
        case 50...59:
            return "It's sweater weather! Wear pants and a light jacket."
        case 40...49:
            return "It's a bit chilly out today. Wear a warm jacket and long pants."
        case 30...39:
            return "It's pretty chilly today. Best wear a winter coat, hat, and gloves."
        case -1000...29:
            return "It's a cold one out there! Bundle up with a winter coat, scarf, hat, and gloves. Bonus for wooly socks."
        default:
            return "Cannot get temperature data to make recommendations."
        }
    }
    
    func getWeatherWearAvatarImage(location: Location) -> UIImage? {
        let gender = UserController.shared.isMale
        guard let feelsLikeTemp = location.weather?.current?.feelsLike else { return #imageLiteral(resourceName: "Male_Partlycloudy_shortshirtsunglassescap") }

        if gender == false && feelsLikeTemp >= 90 {
            return UIImage(named: "female_cloudy_shortsshirtsunglassescap") // f
        }
        else if gender == true && feelsLikeTemp >= 90{
            return UIImage(named: "Male_Cloudy_shortsshirt") //m
        }
        else if gender == false && 70...89 ~= feelsLikeTemp {
            return UIImage(named: "female_partlycloudy_shortsshirt") // f
        }
        else if gender == true && 70...89 ~= feelsLikeTemp {
            return UIImage(named: "Male_Partlycloudy_shortsshirt") // m
        }
        else if gender == true && 70...89 ~= feelsLikeTemp {
            return UIImage(named: "Male_Cloudy_shortsshirt") //m
        }
        else if gender == true && 60...69 ~= feelsLikeTemp {
            return UIImage(named: "Male_Partlycloudy_pantscoat") //m
        }
        else if gender == false && 60...69 ~= feelsLikeTemp {
            return UIImage(named: "female_partlycloudy_pantscoat") //f
        }
        else if gender == true && 40...59 ~= feelsLikeTemp {
            return UIImage(named: "Male_Clearday_pantscoat") //m
        }
        else if gender == false && 40...59 ~= feelsLikeTemp {
            return UIImage(named: "female_clearday_pantscoat")
        }
        else if gender == true && -1000...39 ~= feelsLikeTemp {
            return UIImage(named: "Male_Clearday_bootscoatglovesscarfhat") //m
        }
        else if gender == false && -1000...39 ~= feelsLikeTemp {
            return UIImage(named: "female_clearday_bootscoatglovesscarfhat") //f
        }
        else {
            return UIImage(named: "female_clearday_pantscoat")
        }
    }
    
}
