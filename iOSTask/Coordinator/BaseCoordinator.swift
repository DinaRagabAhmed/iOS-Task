//
//  BaseCoordinator.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import Foundation

class BaseCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var isCompleted : (() -> Void)? // Closure to be executed when vc deallocated from memory
    
    func start() {
        fatalError("start() method must be implemented")
    }
}

