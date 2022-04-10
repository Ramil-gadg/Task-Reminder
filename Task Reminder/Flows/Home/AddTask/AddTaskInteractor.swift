//
//  AddTaskInteractor.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 02.04.2022.
//  
//

import UIKit

final class AddTaskInteractor {

    unowned var presenter: AddTaskPresenter?
    
    var dataStore = DataStore.shared

    func saveTask(taskModel: TaskModel) {
        dataStore.saveTaskModel(taskModel: taskModel) { [weak self] result in
            switch result {
                
            case .success(let task):
                self?.presenter?.onSaveTaskSuccess(with: task)
            case .failure:
                self?.presenter?.onFailure()
            }
        }
    }
}
