//
//  AuthCoordinator.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 05.04.2022.
//  
//

import UIKit

final class AuthCoordinator: BaseCoordinator, AuthCoordinatorOutput {
  
    var finishFlow: CompletionBlock?
    
    private let factory: AuthFactory
    
    init(with factory: AuthFactory,
         router: Routable,
         coordinatorFactory: CoordinatorFactoryProtocol) {
        self.factory = factory
        super.init(router: router, coordinatorFactory: coordinatorFactory)
    }
}

// MARK: - Coordinatable

extension AuthCoordinator: Coordinatable {
    func start() {
        performFlow()
    }
}

// MARK: - Private methods

private extension AuthCoordinator {
    
    func performFlow() {
        let view = factory.makeAuthView()
        
        view.onCompletion = { [weak self] in
//            self?.router.dismissModule()
            self?.finishFlow?()
        }
        
        router.setRootModule(view, hideNavigationBar: false, rootAnimated: true)
    }
    
}
