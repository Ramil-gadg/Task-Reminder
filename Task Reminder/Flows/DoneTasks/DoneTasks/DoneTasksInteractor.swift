//
//  DoneTasksInteractor.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 10.04.2022.
//  
//

import UIKit

final class DoneTasksInteractor {

    unowned var presenter: DoneTasksPresenter?
    
    var dataStore = DataStore.shared
    
    func fetchTasks() {
        dataStore.fetchTaskModels { [weak self] result in
            switch result {
                
            case .success(let tasks):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self?.presenter?.onPresentTasks(with: tasks)
                }
            case .failure:
                self?.presenter?.onFailure()
            }
        }
    }
    
    func deleteTask(with taskId: String) {
        dataStore.deleteTask(
            taskId: taskId,
            completion: { [weak self] result in
                switch result {
                case true:
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [taskId])
                    self?.fetchTasks()
                case false:
                    self?.presenter?.onFailure()
                }
            }
        )
    }
    
    func doneTask(with taskId: String) {
        dataStore.doneTask(
            id: taskId,
            isDone: false,
            completion: { [weak self] result in
                switch result {
                case true:
                    self?.fetchTasks()
                case false:
                    self?.presenter?.onFailure()
                }
            }
        )
    }
    
    func deleteAllTasks() {
        dataStore.deleteDoneTasks(
            completion: { [weak self] result in
                switch result {
                case true:
                    self?.fetchTasks()
                case false:
                    self?.presenter?.onFailure()
                }
            }
        )
    }
}
