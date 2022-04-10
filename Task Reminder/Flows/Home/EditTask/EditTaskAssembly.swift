//
//  EditTaskAssembly.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 03.04.2022.
//  
//

import UIKit

protocol EditTaskAssemblable: EditTaskViewProtocol, EditTaskPresenterOutput {}

enum EditTaskAssembly {
    
    static func assembly(with output: EditTaskPresenterOutput, by input: EditTaskPresenter.Input) {
        let interactor = EditTaskInteractor()
        let presenter = EditTaskPresenter(with: input)
        
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.output = output
        output.presenter = presenter
    }
    
}
