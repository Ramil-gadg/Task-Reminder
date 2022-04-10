//
//  CoordinatorFactory.swift
//
//
//

import UIKit

final class CoordinatorFactory {
    
    private let modulesFactory = ModulesFactory()
    
}

// MARK: - CoordinatorFactoryProtocol

extension CoordinatorFactory: CoordinatorFactoryProtocol {
    
    func makeAuthCoordinator(router: Routable,
                             coordinatorFactory: CoordinatorFactoryProtocol)
    -> Coordinatable & AuthCoordinator {
        AuthCoordinator(
            with: modulesFactory,
            router: router,
            coordinatorFactory: coordinatorFactory
        )
    }
    
    func makePinCodeCoordinator(router: Routable,
                                originalRouter: Routable,
                                coordinatorFactory: CoordinatorFactoryProtocol)
    -> Coordinatable & PinCodeCoordinator {
        PinCodeCoordinator(
            with: modulesFactory,
            router: router,
            originRouter: originalRouter,
            coordinatorFactory: coordinatorFactory
        )
    }
    
    func makeTabBarCoordinator(router: Routable,
                               coordinatorFactory: CoordinatorFactoryProtocol)
    -> Coordinatable & TabBarCoordinatorOutput {
        TabBarCoordinator(
            router: router,
            coordinatorFactory: coordinatorFactory
        )
    }
    
    func makeHomeCoordinator(router: Routable,
                             coordinatorFactory: CoordinatorFactoryProtocol
    ) -> Coordinatable & HomeCoordinatorOutput {
        HomeCoordinator(
            with: modulesFactory,
            router: router,
            coordinatorFactory: coordinatorFactory
        )
    }
    
    func makeDoneTasksCoordinator(router: Routable,
                                  coordinatorFactory: CoordinatorFactoryProtocol
    ) -> Coordinatable & DoneTasksCoordinatorOutput {
        DoneTasksCoordinator(
            with: modulesFactory,
            router: router,
            coordinatorFactory: coordinatorFactory
        )
    }
}

// MARK: - Private methods

private extension CoordinatorFactory {
    
    func router(_ navController: UINavigationController?) -> Routable {
        Router(rootController: navigationController(navController))
    }
    
    func navigationController(_ navController: UINavigationController?)
    -> UINavigationController {
        if let navController = navController {
            return navController
        } else {
            return UINavigationController()
        }
    }
    
}
