//
//  ModulesFactory.swift
//
//
//

import UIKit

final class ModulesFactory:AuthFactory,
                           PinCodeFactory,
                           HomeFactory,
                           DoneTasksFactory {
    
    func makeSetPinCode(with input: SetPinCodePresenter.Input) -> SetPinCodeViewProtocol {
        let view = SetPinCodeViewController()
        SetPinCodeAssembly.assembly(with: view, by: input)
        return view
    }
    
    func makePinCodeView() -> PinCodeViewProtocol {
        let view = PinCodeViewController()
        PinCodeAssembly.assembly(with: view)
        return view
    }
    
    func makeTabBarCoordinator(
        router: Routable,
        coordinatorFactory: CoordinatorFactoryProtocol,
        сoordinators: TaskReminderCoordinators
    ) -> Coordinatable & TabBarCoordinatorOutput {
        TabBarCoordinator(router: router, coordinatorFactory: coordinatorFactory)
    }
    
    func makeAuthView() -> AuthViewProtocol {
        let view = AuthViewController()
        AuthAssembly.assembly(with: view)
        return view
    }
    
    func makeHomeView() -> HomeViewProtocol {
        let view = HomeViewController()
        HomeAssembly.assembly(with: view)
        return view
    }
    
    func makeAddTask() -> AddTaskViewProtocol {
        let view = AddTaskViewController()
        AddTaskAssembly.assembly(with: view)
        return view
    }
    
    func makeEditTask(with input: EditTaskPresenter.Input) -> EditTaskViewProtocol {
        let view = EditTaskViewController()
        EditTaskAssembly.assembly(with: view, by: input)
        return view
    }
    
    func makeDoneTasksView() -> DoneTasksViewProtocol {
        let view = DoneTasksViewController()
        DoneTasksAssembly.assembly(with: view)
        return view
    }
    
}
