//
//  DoneTasksCoordinator.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 10.04.2022.
//  
//

import UIKit

final class DoneTasksCoordinator: BaseCoordinator, DoneTasksCoordinatorOutput {
    
    var finishFlow: CompletionBlock?
    
    private let factory: DoneTasksFactory
    
    init(with factory: DoneTasksFactory,
         router: Routable,
         coordinatorFactory: CoordinatorFactoryProtocol) {
        self.factory = factory
        super.init(router: router, coordinatorFactory: coordinatorFactory)
    }
}

// MARK: - Coordinatable

extension DoneTasksCoordinator: Coordinatable {
    func start() {
        performFlow()
    }
}

// MARK: - Private methods

private extension DoneTasksCoordinator {
    
    func performFlow() {
        let view = factory.makeDoneTasksView()
        
        router.setRootModule(view, hideNavigationBar: false, rootAnimated: true)
    }
    
}
