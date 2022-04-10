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
    
    var tasksDataService: TasksProviderProtocol
    
    init(with tasksProvider: TasksProviderProtocol = TasksProvider()) {
        self.tasksDataService = tasksProvider
    }
    
    func fetchTasks() {
        tasksDataService.fetchTasksModel { [weak self] result in
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
        tasksDataService.deleteTask(
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
        tasksDataService.doneTask(
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
        tasksDataService.deleteDoneTasks(
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
