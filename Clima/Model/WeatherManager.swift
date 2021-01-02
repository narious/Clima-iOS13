//
//  WeatherManager.swift
//  Clima
//
//  Created by Michael on 30/12/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let openWeatherAPIKey = "c74faee9b67eb1353ceb522756a4aa12"
    let openWeatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=c74faee9b67eb1353ceb522756a4aa12&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(self.openWeatherURL)&q=\(cityName)"
        preformRequest(urlString: urlString)
    }
    
    func preformRequest(urlString: String) {
        if let url = URL(string: urlString) {
            
            // 1. Creates a url session i.e. like browser
            let session = URLSession(configuration: .default)
            
            // 2. Creates the task (which is in suspended state) (we can also remove the :Data? parrt
            let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
            }
            // 3. Start the task
            task.resume()
        }
    }
    
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        // Using self at the end referes to its type and do try catch for throwable
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.main.temp)
            print(decodedData.weather[0].description)
        } catch {
            print(error)
        }
        
    }
}
