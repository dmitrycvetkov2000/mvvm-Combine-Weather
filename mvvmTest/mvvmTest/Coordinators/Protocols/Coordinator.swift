//
//  Coordinator.swift
//  mvvmTest
//
//  Created by Дмитрий Цветков on 09.07.2023.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
