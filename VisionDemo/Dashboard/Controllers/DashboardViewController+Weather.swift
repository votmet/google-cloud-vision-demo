//
//  Dashboard+Weather.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/25.
//  Copyright © 2018 vmt. All rights reserved.
//

import UIKit

private let kWeatherFile = "weather.plist"
private let kWeatherAPPID = "YOUR WEATHER APP ID"
private let kWeatherAPI = "https://api.openweathermap.org/data/2.5/weather"


extension DashboardViewController {
    func loadWeather() {
        // 1. load from the cached first
        do {
            let data = try Data(contentsOf: self.weatherURL())
            let json = JSON(data)
            self.weather = json
        } catch {
        }
        // 2. detect if need to fetch online weather data
        self.fetchWeatherIfNeeded()
    }
    func fetchWeatherIfNeeded() {
        if self.isFetchingWeather {
            return
        }
        if let weather = self.weather {
            let now = Date().timeIntervalSince1970
            if let willRetryAt = weather["retryAt"].double {
                if now > willRetryAt {
                    self.fetchWeather()
                }
            } else {
                let updatedAt = weather["updatedAt"].doubleValue
                if now - updatedAt > 6 * 60 * 60 {
                    self.fetchWeather()
                }
            }
        } else {
            self.fetchWeather()
        }
    }
    func fetchWeather() {
        if self.isFetchingWeather {
            return
        }
        // featch from openweather
        if let coordinate = self.locationCoordinate {
            let queryDictionary = [
                "appid": kWeatherAPPID,
                "units": "metric",
                "lat": String(coordinate.latitude),
                "lon": String(coordinate.longitude)
            ]
            var components = URLComponents(string: kWeatherAPI)!
            components.queryItems = queryDictionary.map {
                URLQueryItem(name: $0, value: $1)
            }
            if let url = components.url {
                print(url)
                DispatchQueue.global(qos: .background).async {
                    let session = URLSession.shared
                    let dataTask = session.dataTask(with: url) { (data, response, error) in
                        self.isFetchingWeather = false
                        guard let data = data, error == nil else {
                            print("error: ", error?.localizedDescription ?? "")
                            // fail, update the cache to save the retry time
                            if self.weather != nil {
                                self.weather?["retryAt"] = JSON(Date().timeIntervalSince1970 + 10 * 60)
                                self.cacheWeather()
                            }
                            return
                        }
                        // success
                        var weather = JSON(data)
                        weather["updatedAt"] = JSON(Date().timeIntervalSince1970)
                        DispatchQueue.main.async {
                            self.weather = weather
                        }
                        self.cacheWeather()
                        
                    }
                    dataTask.resume()
                }
                self.isFetchingWeather = true
            }
        }
    }
    private func cacheWeather() {
        if let raw = self.weather?.rawString() {
            do {
                try raw.write(to: self.weatherURL(), atomically: true, encoding: .utf8)
            } catch {}
        }
    }
    private func weatherURL() -> URL {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL.appendingPathComponent(kWeatherFile, isDirectory: false)
    }
}
