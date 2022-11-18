//
//  AppDelegate.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var applicationCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupApplicationCoordinator()
        setupIntialView()
        
        return true
    }
}

