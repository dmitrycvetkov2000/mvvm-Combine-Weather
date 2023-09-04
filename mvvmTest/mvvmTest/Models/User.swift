//
//  User.swift
//  mvvmTest
//
//  Created by Дмитрий Цветков on 09.07.2023.
//

import Foundation

struct User {
    let login: String?
    let password: String?
}

extension User {
    static var logins = [User(login: "Dmitry", password: "12345")]
}
