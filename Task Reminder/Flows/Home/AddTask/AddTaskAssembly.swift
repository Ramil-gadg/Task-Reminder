//
//  AddTaskAssembly.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 02.04.2022.
//  
//

import UIKit

protocol AddTaskAssemblable: AddTaskViewProtocol, AddTaskPresenterOutput {}

enum AddTaskAssembly {
    
    static func assembly(with output: AddTaskPresenterOutput) {
        let interactor = AddTaskInteractor()
        let presenter = AddTaskPresenter()
        
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.output = output
        output.presenter = presenter
    }
    
}
