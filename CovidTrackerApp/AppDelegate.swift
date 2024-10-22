//
//  AppDelegate.swift
//  CovidTrackerApp
//
//  Created by Linh Vu on 2/10/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationViewController = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
        
        return true
    }

}

