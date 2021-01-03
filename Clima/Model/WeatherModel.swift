//
//  WeatherModel.swift
//  Clima
//
//  Created by Michael on 2/1/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let temp: Double
    let weatherId: Int
    
    // Another computed property
    var tempString: String {
        return String(format: "%.1f", temp)
    }
    
    // This is a computed property
    // Rukes must be a var, has a name and a data type.
    var conditionName: String {
        switch weatherId {
            case 200...232:
                return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            case 801...804:
                return "cloud"
            default:
                return "cloud"
            }
    }
}
