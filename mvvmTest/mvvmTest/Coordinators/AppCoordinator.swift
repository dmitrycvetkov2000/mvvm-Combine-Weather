//
//  AppCoordinator.swift
//  mvvmTest
//
//  Created by Дмитрий Цветков on 09.07.2023.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var isLoggedIn = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if isLoggedIn {
            showScore()
        } else {
            showLogin()
        }
    }
    
    func showLogin() {
        let vc = LoginViewController.createObject()
        vc.coordinator = self
        vc.viewModel = LoginViewModel()
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showScore() {
        let vc = ScoreViewController.createObject()
        vc.coordinator = self
        vc.viewModel = ScoreViewModel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            self.navigationController.viewControllers.removeAll()
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func showMain(login: String) {
        let vc = MainViewController.createObject()
        vc.coordinator = self
        let viewModel = MainViewModel()
        vc.viewModel = viewModel
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showDatail() {
        let vc = DetailsViewController.createObject()
        vc.coordinator = self
        let viewModel = DetailViewModel()
        vc.viewModel = viewModel
        viewModel.model = UserData.userData
        
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(vc, animated: true)
    }
    
}
