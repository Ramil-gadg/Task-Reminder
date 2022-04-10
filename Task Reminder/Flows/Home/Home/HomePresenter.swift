//
//  HomePresenter.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 26.03.2022.
//  
//

import UIKit

protocol HomePresenterInput: AnyObject {

    func onStart(animating: Bool)
    func onDeleteTask(with taskId: String)
    func onDoneTask(with taskId: String)
}

protocol HomePresenterOutput: BasePresenterOutput {
    
    var presenter: HomePresenterInput? { get set }
    
    func prepareData(with tasks: [TaskModel])
}

final class HomePresenter {
    
    weak var notifiations = NotificationManager.shared

    weak var output: HomePresenterOutput?
    
    var interactor: HomeInteractor?
    
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
        let tasksInWork = tasks.filter { $0.isDone == false }
        output?.prepareData(with: tasksInWork)
    }
    
    func onFailure() {
        output?.onAnimating(isStart: false)
    }
}

// MARK: - HomePresenterInput

extension HomePresenter: HomePresenterInput {
    
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

}
