//
//  DoneTasksPresenter.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 10.04.2022.
//  
//

import UIKit

protocol DoneTasksPresenterInput: AnyObject {
    
    func onStart(animating: Bool)
    func onDeleteTask(with taskId: String)
    func onDoneTask(with taskId: String)
    func deleteAllTasks()
}

protocol DoneTasksPresenterOutput: BasePresenterOutput {
    
    var presenter: DoneTasksPresenterInput? { get set }
    
    func prepareData(with tasks: [TaskModel])
}

final class DoneTasksPresenter {

    weak var output: DoneTasksPresenterOutput?
    
    var interactor: DoneTasksInteractor?
    weak var notifiations = NotificationManager.shared
        
    func onPresentTasks(with tasks: [TaskModel]) {
        tasks.forEach { task in
            if let time = task.endTime, time > Date() {
                switch task.isDone {
                    
                case true:
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id])
                case false:
                    notifiations?.sendLocaleNotification(
                        with: task.name,
                        body: task.task,
                        id: task.id,
                        interval: time.timeIntervalSince(Date())
                    )
                }
            } else {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id])
            }
        }
        output?.onAnimating(isStart: false)
        let doneTasks = tasks.filter { $0.isDone == true }
        output?.prepareData(with: doneTasks)
    }
    
    func onFailure() {
        output?.onAnimating(isStart: false)
    }
}

// MARK: - DoneTasksPresenterInput

extension DoneTasksPresenter: DoneTasksPresenterInput {
   
    func onStart(animating: Bool) {
        output?.onAnimating(isStart: animating)
        interactor?.fetchTasks()
    }
    
    func onDeleteTask(with taskId: String) {
        output?.onAnimating(isStart: true)
        interactor?.deleteTask(with: taskId)
    }
    
    func onDoneTask(with taskId: String) {
        output?.onAnimating(isStart: true)
        interactor?.doneTask(with: taskId)
    }
    
    func deleteAllTasks() {
        output?.onAnimating(isStart: true)
        interactor?.deleteAllTasks()
    }

}
