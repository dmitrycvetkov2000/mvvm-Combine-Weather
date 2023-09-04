//
//  MainViewModel.swift
//  mvvmTest
//
//  Created by Дмитрий Цветков on 09.07.2023.
//

import Foundation
import Combine

class MainViewModel {
    @Published var city = ""
    @Published var curWeather = Weather.placeholder
    
    var cancellables = Set<AnyCancellable>()
    init() {
        $city
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { (city: String) -> AnyPublisher<Weather, Never> in
                WeatherApi.shared.fetchWeather(for: city)
            }
            .assign(to: \.curWeather, on: self)
            .store(in: &cancellables)
    }
}
