//
//  AppDelegate.swift
//  mvvmTest
//
//  Created by Дмитрий Цветков on 09.07.2023.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordintaor: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navController = UINavigationController()
        coordintaor = AppCoordinator(navigationController: navController)
        coordintaor?.start()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }




}

