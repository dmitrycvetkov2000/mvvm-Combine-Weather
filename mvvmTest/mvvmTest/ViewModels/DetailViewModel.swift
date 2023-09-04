//
//  DetailViewModel.swift
//  mvvmTest
//
//  Created by Дмитрий Цветков on 09.07.2023.
//

import Foundation
import Combine

class DetailViewModel {
    var model: UserData?
    @Published var back: Bool = false
    @Published var textForReplay: String = ""
}
