//
//  HomeCoordinator.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 26.03.2022.
//  
//

import UIKit

final class HomeCoordinator: BaseCoordinator, HomeCoordinatorOutput {
    
    var finishFlow: CompletionBlock?
    
    private let factory: HomeFactory
    
    init(with factory: HomeFactory,
         router: Routable,
         coordinatorFactory: CoordinatorFactoryProtocol) {
        self.factory = factory
        super.init(router: router, coordinatorFactory: coordinatorFactory)
    }
}

// MARK: - Coordinatable

extension HomeCoordinator: Coordinatable {
    func start() {
        performFlow()
    }
}

// MARK: - Private methods

private extension HomeCoordinator {
    
    func performFlow() {
        let view = factory.makeHomeView()
        view.onCompletion = finishFlow
        
        view.onAddTask = { [weak self] in
            self?.performAddTask(with: view)
        }
        
        view.onEditTask = { [weak self, weak view] task in
            let input = EditTaskPresenter.Input(taskModel: task)
            self?.performEditTask(with: view, input: input)
        }
        router.setRootModule(view, hideNavigationBar: false, rootAnimated: true)
    }
    
    func performAddTask(with completion: AddTaskProtocol) {
        let view = factory.makeAddTask()
        view.onCompletion = { [weak self, weak completion] in
            completion?.startTimer()
            self?.router.dismissModule()
        }
        
        view.taskAdded = { [weak self, weak completion] task in
            
            completion?.taskAdded(with: task)
            self?.router.dismissModule()
        }
        
        let navC = BaseNavigationController(rootViewController: view as! UIViewController)
        router.presentOverfullscreen(navC, animated: false)
    }
    
    func performEditTask(with completion: EditTaskProtocol?, input: EditTaskPresenter.Input) {
        let view = factory.makeEditTask(with: input)
        view.onCompletion = { [weak self, weak completion] in
            completion?.startTimer()
            self?.router.popModule()
        }
        
        view.taskEdit = { [weak self, weak completion] in
            self?.router.popModule()
            completion?.taskEdit()
        }
        
        router.push(view)
    }
}
