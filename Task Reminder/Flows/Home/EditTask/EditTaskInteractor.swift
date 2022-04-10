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
    
    var dataStore = DataStore.shared

    func editTask(with taskModel: TaskModel) {
        dataStore.changeTask(task: taskModel) {[weak self] changed in
            switch changed {
                
            case true:
                self?.presenter?.onTaskChanghed()
                
            case false:
                self?.presenter?.onFailure()
                
            }
        }
    }
}
