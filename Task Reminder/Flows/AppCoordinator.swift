//
//  AppCoordinator.swift
//
//

import Foundation

final class AppCoordinator: BaseCoordinator {
    
    private let factory: CoordinatorFactoryProtocol
    
    private let pinCodeManager = PinManager.shared
    
    private var instructor: LaunchInstructor {
        LaunchInstructor.setup()
    }
    
    static var childCoordinators: [Coordinatable] = []
    
    init(router: Routable, factory: CoordinatorFactory, сoordinators: TaskReminderCoordinators) {
        self.factory = factory
        
        super.init(router: router, coordinatorFactory: factory)
    }
    
    enum LaunchInstructor {
        case auth
        case main
        case createPin(token: String)
        case inputPin
        
        static func setup() -> LaunchInstructor {
            
            if SessionManager.didSetPin == false,
               SessionManager.token == nil {
                return .auth
            } else if SessionManager.didSetPin == false,
                      let token = SessionManager.token,
                      SessionManager.skipCreatePin == false {
                return .createPin(token: token)
            } else if SessionManager.didSetPin == true,
                      SessionManager.token == nil {
                return .inputPin
            } else if SessionManager.didSetPin == false,
                      SessionManager.token != nil,
                      SessionManager.skipCreatePin == true {
                return .main
            } else if SessionManager.didSetPin == true,
                      SessionManager.token != nil {
                return .main
            } else {
                let token = "123456"
                SessionManager.token = token
                return .createPin(token: token)
            }
            
        }
    }
    
}

// MARK: - Coordinatable

extension AppCoordinator: Coordinatable {
    func start() {
        switch self.instructor {
        case .auth:
            performAuth()
        case .main:
            performTabBar()
        case .createPin(let token):
            performCreatePinCode(with: SetPinCodePresenter.Input(token: token))
        case .inputPin:
            performPinCode()
        }
    }
}

// MARK: - Private methods

private
extension AppCoordinator {
    
    func performAuth() {
        let coordinator = factory.makeAuthCoordinator(
            router: router,
            coordinatorFactory: factory
        )
        
        coordinator.finishFlow = { [weak self] in
            
            self?.removeDependency(coordinator)
            
            self?.router.dismissModule()
            self?.start()
        }
        
        addDependency(coordinator)
        coordinator.start()
    }
    
    func performTabBar() {
        let coordinator = factory.makeTabBarCoordinator(
            router: router,
            coordinatorFactory: factory
        )
        
        // отладочная информация о текущих координаторах
        AppCoordinator.childCoordinators.forEach({
            print("childCoordinators: ", String(describing: $0))
        })
        
        coordinator.finishFlow = { [weak self] in
            guard
                let self = self else { return }
            
            AppCoordinator.childCoordinators.forEach({
                self.removeDependency($0)
                $0.router.dismissModule()
            })
            
            self.start()
        }
        
        addDependency(coordinator)
        coordinator.start()
    }
    
    func performCreatePinCode(with input: SetPinCodePresenter.Input) {
        let coordinator = factory.makePinCodeCoordinator(
            router: router,
            originalRouter: router,
            coordinatorFactory: factory
        )
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            guard let coordinator = coordinator else {
                return
            }
            self?.removeDependency(coordinator)
            self?.start()
        }
        
        coordinator.startCreatePinCode(with: input)
        
        addDependency(coordinator)
    }
    
    func performPinCode() {
        let coordinator = factory.makePinCodeCoordinator(
            router: router,
            originalRouter: router,
            coordinatorFactory: factory
        )
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            guard let coordinator = coordinator else {
                return
            }
            self?.removeDependency(coordinator)
            
            self?.router.dismissModule()
            self?.start()
        }
        
        coordinator.start()
        
        addDependency(coordinator)
    }
}
