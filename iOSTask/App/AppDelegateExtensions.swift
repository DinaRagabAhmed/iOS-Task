//
//  AppDelegateExtensions.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import UIKit

// MARK: - Responsible For handle application flow
extension AppDelegate {
    
    func setupApplicationCoordinator() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        applicationCoordinator = AppCoordinator(window: window)
    }
    
    // Setup entry screen
    func setupIntialView() {
        applicationCoordinator?.start()
    }
}
