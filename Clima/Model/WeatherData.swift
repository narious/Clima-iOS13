//
//  WeatherData.swift
//  Clima
//
//  Created by Michael on 1/1/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData : Decodable {
    let name: String
    // main in the JSON is an Object so need to create another struct
    let main: Main
    let weather: [Weather]
}

// Property names must match JSON excatly
struct Main : Decodable {
    let temp: Double
}

struct Weather : Decodable {
    let description: String
    let id: Int
}
