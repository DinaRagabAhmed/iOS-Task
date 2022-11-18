//
//  AppCoordinator.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import UIKit

class AppCoordinator: BaseCoordinator {
        
    private let window: UIWindow
    private var router: Routing?
    private var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        return navigationController
    }()

    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        navigateToDocumentListVC()
    }
 
    func startCoordinator(coordinator: BaseCoordinator) {
        self.add(coordinator: coordinator)
        
        coordinator.isCompleted = { [weak self, weak coordinator] in
            guard let coordinator = coordinator else {
                return
            }
            self?.remove(coordinator: coordinator)
        }
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        coordinator.start()
    }
    
    func navigateToDocumentListVC() {
        let router = Router(navigationController: navigationController)
        let documentListCoordinator = DocumentListCoordinator(router: router)

        self.router = router
        self.startCoordinator(coordinator: documentListCoordinator)
    }
}

