//
//  CoordinatorFactoryProtocol.swift
//  delta-ohrana
//
//  Created by Sergey Nazarov on 11.01.2022.
//  
//

import UIKit

protocol CoordinatorFactoryProtocol {
    
    /// Авторизация
    func makeAuthCoordinator(router: Routable,
                             coordinatorFactory: CoordinatorFactoryProtocol)
    -> Coordinatable & AuthCoordinator
    
    /// Пин-Код
    func makePinCodeCoordinator(router: Routable,
                                originalRouter: Routable,
                                coordinatorFactory: CoordinatorFactoryProtocol)
    -> Coordinatable & PinCodeCoordinator
    
    ///  TabBar
    func makeTabBarCoordinator(
        router: Routable,
        coordinatorFactory: CoordinatorFactoryProtocol
    ) -> Coordinatable & TabBarCoordinatorOutput
    
    ///  Home
    func makeHomeCoordinator(
        router: Routable,
        coordinatorFactory: CoordinatorFactoryProtocol
    ) -> Coordinatable & HomeCoordinatorOutput
    
    ///  DoneTasks
    func makeDoneTasksCoordinator(
        router: Routable,
        coordinatorFactory: CoordinatorFactoryProtocol
    ) -> Coordinatable & DoneTasksCoordinatorOutput
    
}
