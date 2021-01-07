//
//  WeatherManager.swift
//  Clima
//
//  Created by Michael on 30/12/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) -> Void
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let openWeatherAPIKey = "c74faee9b67eb1353ceb522756a4aa12"
    let openWeatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=c74faee9b67eb1353ceb522756a4aa12&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(self.openWeatherURL)&q=\(cityName)"
        preformRequest(with: urlString)
    }
    //Method overloading
    func fetchWeather(lat: Double, lon: Double) {
        let urlString = "\(self.openWeatherURL)&lat=\(lat)&lon=\(lon)"
        preformRequest(with: urlString)
    }
    
    func preformRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            
            // 1. Creates a url session i.e. like browser
            let session = URLSession(configuration: .default)
            
            // 2. Creates the task (which is in suspended state) (we can also remove the :Data? parrt
            let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                    
                }
            }
            // 3. Start the task
            task.resume()
        }
    }
    
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        // Using self at the end referes to its type and do try catch for throwable
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            let name = decodedData.name
            
            let weather = WeatherModel(cityName: name, temp: temp, weatherId: id)
            return weather
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}
