//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        
        // Sets the delegate as itself
        locationManager.delegate = self
        searchTextField.delegate = self
        weatherManager.delegate = self
        
        //Asks for permission from user cause location
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    @IBAction func locationButtonPressed(_ sender: UIButton) {
    }
    
}

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    // What to do when "return" button pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    // When they deselect the text field
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (searchTextField.text != nil) {
            return true
        } else {
            textField.placeholder = "You should really type something..."
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityName = searchTextField.text {
            weatherManager.fetchWeather(cityName: cityName)
        }
        searchTextField.text = nil
    }
    
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    // Formated to follow delegate method to include self
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        // This is a closure i.e. anonymous function
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    //Error checking
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
             print(error)
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last {
            weatherManager.fetchWeather(lat: loc.coordinate.latitude, lon: loc.coordinate.longitude)
        }
    }
}
