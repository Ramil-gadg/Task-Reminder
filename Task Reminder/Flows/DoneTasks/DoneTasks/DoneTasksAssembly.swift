//
//  DoneTasksAssembly.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 10.04.2022.
//  
//

import UIKit

protocol DoneTasksAssemblable: DoneTasksViewProtocol, DoneTasksPresenterOutput {}

enum DoneTasksAssembly {
    
    static func assembly(with output: DoneTasksPresenterOutput) {
        let interactor = DoneTasksInteractor()
        let presenter = DoneTasksPresenter()
        
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.output = output
        output.presenter = presenter
    }
    
}
