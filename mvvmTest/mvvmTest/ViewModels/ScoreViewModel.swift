//
//  ViewModel2.swift
//  mvvmTest
//
//  Created by Дмитрий Цветков on 09.07.2023.
//

import Foundation
import Combine

class ScoreViewModel {
    @Published var score = 0
    
    var isThirdScore: AnyPublisher<Bool, Never> {
        $score
            .map { $0 > 2 }
            .eraseToAnyPublisher()
    }
    
    func scoreButtonPressed() {
        score += 1
    }
}
