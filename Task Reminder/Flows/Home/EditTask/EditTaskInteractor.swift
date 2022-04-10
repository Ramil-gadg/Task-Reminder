//
//  EditTaskInteractor.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 03.04.2022.
//  
//

import UIKit

final class EditTaskInteractor {
    
    unowned var presenter: EditTaskPresenter?
    
    var tasksDataService: TasksProviderProtocol
    
    init(with tasksProvider: TasksProviderProtocol = TasksProvider()) {
        self.tasksDataService = tasksProvider
    }
    
    func editTask(with taskModel: TaskModel) {
        tasksDataService.changeTask(task: taskModel) {[weak self] changed in
            switch changed {
                
            case true:
                self?.presenter?.onTaskChanghed()
                
            case false:
                self?.presenter?.onFailure()
                
            }
        }
    }
}
