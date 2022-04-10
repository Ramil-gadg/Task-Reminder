//
//  CoreDataManager.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 29.03.2022.
//

import Foundation
import UIKit
import CoreData

class DataStore {
    
    static var shared = DataStore()
    
    private init() {}
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveTaskModel(taskModel: TaskModel, completion: @escaping (Result<TaskModel, Error>) -> Void) {
        let cdTaskModel = CDTaskModel(context: context)
        cdTaskModel.name = taskModel.name
        cdTaskModel.task = taskModel.task
        cdTaskModel.id = taskModel.id
        cdTaskModel.startTime = taskModel.startTime
        cdTaskModel.endTime = taskModel.endTime
        cdTaskModel.isDone = taskModel.isDone
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            
            do {
                try self.context.save()
                DispatchQueue.main.async {
                    completion(.success(taskModel))
                }
            } catch let error as NSError {
                DispatchQueue.main.async {
                    completion(.failure(error))
                    print (error.localizedDescription)
                }
            }
        }
    }
    
    func fetchTaskModels (completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        var cdTaskModels = [CDTaskModel]()
        var taskModels = [TaskModel]()
        let request:NSFetchRequest<CDTaskModel> = CDTaskModel.fetchRequest()
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            
            do {
                cdTaskModels = try self.context.fetch(request)
                taskModels = cdTaskModels.compactMap {TaskModel(with: $0) }
                
            } catch let error as NSError {
                DispatchQueue.main.async {
                    completion(.failure(error))
                    print (error.localizedDescription)
                }
                
            }
            DispatchQueue.main.async {
                completion(.success(taskModels))
            }
        }
    }
    
    
    func changeTask(
        task: TaskModel,
        completion: @escaping (Bool) -> Void
    ) {
        let request: NSFetchRequest<CDTaskModel> = CDTaskModel.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", task.id)
        do {
            let tasks = try context.fetch(request)
            if let cdTask = tasks.first {
                cdTask.name = task.name
                cdTask.task = task.task
                cdTask.isDone = task.isDone
                cdTask.doneTime = task.doneTime
                cdTask.endTime = task.endTime
                try context.save()
                completion(true)
            }
        } catch let error as NSError {
            completion(false)
            print(error.localizedDescription)
        }
    }
    
    func doneTask(
        id: String,
        isDone: Bool,
        completion: @escaping (Bool) -> Void
    ) {
        let request: NSFetchRequest<CDTaskModel> = CDTaskModel.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        do {
            let tasks = try context.fetch(request)
            if let cdTask = tasks.first {
                cdTask.isDone = isDone
                cdTask.doneTime =  isDone ? Date() : nil
                try context.save()
                completion(true)
            }
        } catch let error as NSError {
            completion(false)
            print(error.localizedDescription)
        }
    }
    
    func deleteTask(taskId: String, completion: @escaping (Bool) -> Void) {
        let request: NSFetchRequest<CDTaskModel> = CDTaskModel.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", taskId)
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            
            do {
                let tasks = try self.context.fetch(request)
                if let task = tasks.first {
                    self.context.delete(task)
                    try self.context.save()
                    completion(true)
                }
                
            } catch let error as NSError {
                completion(false)
                print (error.localizedDescription)
            }
        }
    }
    
    func deleteDoneTasks(completion: @escaping (Bool) -> Void) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CDTaskModel")
        request.predicate = NSPredicate(format: "isDone = true")
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            
            do {
                if let tasks = try self.context.fetch(request) as? [CDTaskModel] {
                    tasks.forEach { [weak self ] in
                        self?.context.delete($0) }
                }
                try self.context.save()
                completion(true)
            } catch let error as NSError {
                completion(false)
                print (error.localizedDescription)
            }
        }
    }
}
