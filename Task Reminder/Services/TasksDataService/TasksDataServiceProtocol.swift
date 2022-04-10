//
//  TasksDataServiceProtocol.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 10.04.2022.
//

import Foundation

protocol TasksProviderProtocol: AnyObject {
    
    /// создать задачу
    func createTaskModel(taskModel: TaskModel, completion: @escaping (Result<TaskModel, Error>) -> Void)
    
    /// получить все задания
    func fetchTasksModel(completion: @escaping (Result<[TaskModel], Error>) -> Void)
    
    /// поменять задание полностью
    func changeTask(
        task: TaskModel,
        completion: @escaping (Bool) -> Void
    )
    
    /// поменять у задания свойство выполнено или нет
    func doneTask(
        id: String,
        isDone: Bool,
        completion: @escaping (Bool) -> Void
    )
    
    /// удалить задачу
    func deleteTask(taskId: String, completion: @escaping (Bool) -> Void)
    
    /// удалить все выполненные задачи
    func deleteDoneTasks(completion: @escaping (Bool) -> Void)
    
}
