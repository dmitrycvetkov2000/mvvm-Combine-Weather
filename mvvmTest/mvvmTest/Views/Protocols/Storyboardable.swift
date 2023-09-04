//
//  Storyboardable.swift
//  mvvmTest
//
//  Created by Дмитрий Цветков on 09.07.2023.
//

import UIKit

protocol Storyboardable {
    static func createObject() -> Self
}

extension Storyboardable where Self: UIViewController {
    static func createObject() -> Self {
        return self.init()
    }
}
