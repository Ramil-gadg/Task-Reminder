//
//  SceneDelegate.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 26.03.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var coreDataManager = CoreDataManager.shared
    
    private lazy var coordinator: Coordinatable = makeCoordinator()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        coordinator.start()
        
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        PinManager.shared.willEnterForeground()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        PinManager.shared.didEnterBackground()

        coreDataManager.saveContext()
    }
}

// MARK: - Private methods

private extension SceneDelegate {
    
    func makeCoordinator() -> Coordinatable {
        let navController = BaseNavigationController()
        let сoordinators = TaskReminderCoordinators(childCoordinators: [])
        
        window?.rootViewController = navController
        
        return AppCoordinator(
            router: Router(rootController: navController),
            factory: CoordinatorFactory(),
            сoordinators: сoordinators
        )
    }
}

