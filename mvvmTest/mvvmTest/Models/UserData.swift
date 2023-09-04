//
//  UserData.swift
//  mvvmTest
//
//  Created by Дмитрий Цветков on 09.07.2023.
//

import Foundation

struct UserData {
    var name: String?
    var email: String?
}

extension UserData {
    static var userData = UserData(name: "Дмитрий", email: "dimacvetkov2000@mail.ru")
}
