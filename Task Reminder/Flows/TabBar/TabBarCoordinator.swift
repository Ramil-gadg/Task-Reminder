//
//  TabBarCoordinator.swift
//  
//

import UIKit

enum TabItem: String, CaseIterable {
    case home = "tab_main"
    case done = "tab_done_tasks"
    
    var iconTitle: String {
        self.rawValue.localized
    }
    
    var iconSelected: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "clock.circle.fill")
        case .done:
            return UIImage(systemName: "clock.badge.checkmark.fill")
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "clock.circle")
        case .done:
            return UIImage(systemName: "clock.badge.checkmark")
        }
    }
}

final class TabBarCoordinator: BaseCoordinator, TabBarCoordinatorOutput {
  
    var finishFlow: CompletionBlock?
    
    private let modulesFactory = ModulesFactory()
    
    private var itemRouters = [TabItem: Router]()
    
    private weak var homeCoordinator: HomeCoordinator?
    private weak var doneTasksCoordinator: DoneTasksCoordinator?
    
    private let tabBarViewController = TabBarController()
    
    private let pinCodeManager = PinManager.shared
    
    override init(router: Routable,
                  coordinatorFactory: CoordinatorFactoryProtocol) {
        
        super.init(router: router, coordinatorFactory: coordinatorFactory)
        
        TabItem.allCases.forEach {
            initCoordinator(type: $0)
        }
        
        pinCodeManager.pinCodeTrigger = { [weak self] in
            if SessionManager.didSetPin == true {
                self?.performPinCode()
            }
        }
    }
    
    // swiftlint:disable function_body_length
    func initCoordinator(type: TabItem) {
  
        let navController = BaseNavigationController()
        let router = Router(rootController: navController)
        
        navController.tabBarItem.title = type.iconTitle
        navController.tabBarItem.image = type.icon
        navController.tabBarItem.selectedImage = type.iconSelected
        
        switch type {
            
        case .home:
            let coordinator = HomeCoordinator(
                with: modulesFactory,
                router: router,
                coordinatorFactory: coordinatorFactory
            )
            homeCoordinator = coordinator
            
            coordinator.finishFlow = { [weak self] in
                self?.removeTabDependecies()
                self?.finishFlow?()
                self?.router.dismissModule()
            }
            
            coordinator.start()
            addDependency(coordinator)
            
        case .done:
            let coordinator = DoneTasksCoordinator(
                with: modulesFactory,
                router: router,
                coordinatorFactory: coordinatorFactory
            )
            doneTasksCoordinator = coordinator
            coordinator.start()
            addDependency(coordinator)
        }
        
        itemRouters[type] = router
    }

    deinit {
        print("TabBarCoordinator is deinit")
    }
}

// MARK: - Coordinatable

extension TabBarCoordinator: Coordinatable {
    func start() {
        performFlow()
    }
}

// MARK: - Private methods

private extension TabBarCoordinator {
    
    func performFlow() {
        var controllers = [UIViewController]()
        TabItem.allCases.forEach { tab in
            if let vc = itemRouters[tab]?.toPresent {
                controllers.append(vc)
            }
        }
        
        self.tabBarViewController.setViewControllers(controllers, animated: false)
        
        tabBarViewController.selectedIndex = 0
        router.setRootModule(tabBarViewController, hideNavigationBar: true, rootAnimated: false)
    }
    
    func removeTabDependecies() {
        for item in currentCoordinators {
            self.removeDependency(item)
            print(AppCoordinator.childCoordinators.count)
        }
    }
    
    func performPinCode() {
        
        let topCoordinator = AppCoordinator.childCoordinators.last
        guard let origRouter = topCoordinator?.router,
              (topCoordinator as? PinCodeCoordinator) == nil else {
            return
        }
        
        let navController = BaseNavigationController()
        let coordinator = coordinatorFactory.makePinCodeCoordinator(
            router: Router(rootController: navController),
            originalRouter: origRouter,
            coordinatorFactory: coordinatorFactory
        )
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            guard let coordinator = coordinator else {
                return
            }
            self?.removeDependency(coordinator)
        }
        
        coordinator.onCreatePinFlow = { [weak self, weak coordinator] in
            guard let coordinator = coordinator else {
                return
            }
            self?.removeDependency(coordinator)
            self?.removeTabDependecies()
            self?.finishFlow?()
            self?.router.dismissModule()
        }
        
        coordinator.startPinByOrigin()
        
        addDependency(coordinator)
    }
}
