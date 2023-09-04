//
//  WeatherApi.swift
//  mvvmTest
//
//  Created by Дмитрий Цветков on 19.07.2023.
//



// 936da458c98be7b6cba01046fb772f93 API key
import Foundation
import Combine

class WeatherApi {
    static let shared = WeatherApi()
    
    private init() {}
    
    let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    let apiKey = "936da458c98be7b6cba01046fb772f93"
    
    private func absoluteURL(city: String) -> URL? {
        let queryURL = URL(string: baseUrl)!
        let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else { return nil}
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        return urlComponents.url
    }
    
    func fetchWeather(for city: String) -> AnyPublisher<Weather, Never> {
        guard let url = absoluteURL(city: city) else {
            return Just(Weather.placeholder)
                .eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Weather.self, decoder: JSONDecoder())
            .catch { error in Just(Weather.placeholder)}
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
