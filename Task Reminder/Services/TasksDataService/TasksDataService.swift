//
//  TasksDataService.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 10.04.2022.
//

import Foundation

class TasksProvider {
    let localeTasksStorage = LocaleTasksStorage()
    
//    let tasksRemoteDataService = TasksRemoteDataService()
}

// MARK: - TasksProviderProtocol

extension TasksProvider: TasksProviderProtocol {
    
    func createTaskModel(taskModel: TaskModel, completion: @escaping (Result<TaskModel, Error>) -> Void) {
        localeTasksStorage.saveTaskModel(taskModel: taskModel, completion: completion)
    }
    
    func fetchTasksModel(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        localeTasksStorage.fetchTasksModels(completion: completion)
    }
    
    func changeTask(task: TaskModel, completion: @escaping (Bool) -> Void) {
        localeTasksStorage.changeTask(task: task, completion: completion)
    }
    
    func doneTask(id: String, isDone: Bool, completion: @escaping (Bool) -> Void) {
        localeTasksStorage.doneTask(id: id, isDone: isDone, completion: completion)
    }
    
    func deleteTask(taskId: String, completion: @escaping (Bool) -> Void) {
        localeTasksStorage.deleteTask(taskId: taskId, completion: completion)
    }
    
    func deleteDoneTasks(completion: @escaping (Bool) -> Void) {
        localeTasksStorage.deleteDoneTasks(completion: completion)
    }
    
}
