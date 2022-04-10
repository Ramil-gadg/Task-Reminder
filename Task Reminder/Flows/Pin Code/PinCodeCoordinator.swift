//
//  PinCodeCoordinator.swift
//  delta-ohrana
//
//  Created by Sergey Nazarov on 19.01.2022.
//  
//

import UIKit

final class PinCodeCoordinator: BaseCoordinator, PinCodeCoordinatorOutput {
 
    var finishFlow: CompletionBlock?
    var onCreatePinFlow: CompletionBlock?
    
    private let factory: PinCodeFactory
    private let originRouter: Routable
    
    init(with factory: PinCodeFactory,
         router: Routable,
         originRouter: Routable,
         coordinatorFactory: CoordinatorFactoryProtocol) {
        self.factory = factory
        self.originRouter = originRouter
        super.init(router: router, coordinatorFactory: coordinatorFactory)
    }
}

// MARK: - Coordinatable

extension PinCodeCoordinator: Coordinatable {
    func start() {
        performFlow()
    }
    
    func startPinByOrigin() {
        performPinByOrigin()
    }
    
    func startCreatePinCode(with input: SetPinCodePresenter.Input) {
        performCreatePin(with: input)
    }
}

// MARK: - Private methods

private extension PinCodeCoordinator {
    
    func performFlow() {
        let view = factory.makePinCodeView()
        
        view.onCompletion = finishFlow
        
        router.setRootModule(view, hideNavigationBar: false, rootAnimated: true)
    }
    
    func performPinByOrigin() {
        let view = factory.makePinCodeView()
        
        view.onCompletion = { [weak self] in
            self?.router.dismissModule()
            if SessionManager.token == nil {
                self?.onCreatePinFlow?()
            } else {
                self?.finishFlow?()
            }
        }
        
        router.setRootModule(view, hideNavigationBar: false, rootAnimated: true)
        originRouter.presentOverfullscreen(router.toPresent, animated: true)
    }
    
    func performCreatePin(with input: SetPinCodePresenter.Input) {
        let view = factory.makeSetPinCode(with: input)
        
        view.onCompletion = { [weak self] in
            self?.finishFlow?()
        }
        
        router.setRootModule(view, hideNavigationBar: false, rootAnimated: false)
    }
}
