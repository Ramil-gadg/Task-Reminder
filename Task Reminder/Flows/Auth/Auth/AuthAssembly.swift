//
//  AuthAssembly.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 05.04.2022.
//  
//

import UIKit

protocol AuthAssemblable: AuthViewProtocol, AuthPresenterOutput {}

enum AuthAssembly {
    
    static func assembly(with output: AuthPresenterOutput) {
        let interactor = AuthInteractor()
        let presenter = AuthPresenter()
        
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.output = output
        output.presenter = presenter
    }
    
}
