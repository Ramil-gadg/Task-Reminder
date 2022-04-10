//
//  BaseCoordinator.swift
//
//
//

import Foundation

class BaseCoordinator {
    
    private (set) var router: Routable
    private (set) var currentCoordinators: [Coordinatable]
    
    let coordinatorFactory: CoordinatorFactoryProtocol
    
    init(router: Routable, coordinatorFactory: CoordinatorFactoryProtocol) {
        self.router = router
        self.currentCoordinators = []
        self.coordinatorFactory = coordinatorFactory
    }
        
    // Add only unique object
    
    func addDependency(_ coordinator: Coordinatable) {
        
        for element in currentCoordinators where element === coordinator {
            return
        }
        
        for element in AppCoordinator.childCoordinators where element === coordinator {
            return
        }
        
        AppCoordinator.childCoordinators.append(coordinator)
        currentCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: Coordinatable?) {
        
        guard
            AppCoordinator.childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }
        
        for (index, element) in AppCoordinator.childCoordinators.enumerated() where element === coordinator {
            AppCoordinator.childCoordinators.remove(at: index)
            break
        }
        
        for (index, element) in currentCoordinators.enumerated() where element === coordinator {
            currentCoordinators.remove(at: index)
            break
        }
    }
}
