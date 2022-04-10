//
//  HomeAssembly.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 26.03.2022.
//  
//

import UIKit

protocol HomeAssemblable: HomeViewProtocol, HomePresenterOutput {}

enum HomeAssembly {
    
    static func assembly(with output: HomePresenterOutput) {
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.output = output
        output.presenter = presenter
    }
    
}
