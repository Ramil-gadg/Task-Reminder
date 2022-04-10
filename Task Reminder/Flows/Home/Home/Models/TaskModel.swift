//
//  TaskModel.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 30.03.2022.
//

import UIKit

class TaskModel {
    
    
    var name: String
    var id: String
    var task: String
    var doneTime: Date?
    var startTime: Date
    
    var isDone: Bool = false
    
    var endTime: Date?
    
    init(with name: String,
         task: String,
         endTime: Date?
    ) {
        self.name = name
        self.task = task
        self.startTime = Date()
        self.endTime = endTime
        self.id = UUID().uuidString
    }
    
    convenience init(with cdTaskModel: CDTaskModel) {
        self.init(with: cdTaskModel.name!, task: cdTaskModel.task!, endTime: cdTaskModel.endTime)
        self.id = cdTaskModel.id!
        self.startTime = cdTaskModel.startTime!
        self.endTime = cdTaskModel.endTime
        self.isDone = cdTaskModel.isDone
        self.doneTime = cdTaskModel.doneTime
    }
    
    /// полное время на задачу
    var allTimeToDo: TimeInterval? {
        guard let endTime = endTime
        else {
            return nil
        }
        return endTime.timeIntervalSince(startTime)
    }
    
    /// пройденное время задачи
    var passedTime: TimeInterval {
        Date().timeIntervalSince(startTime)
    }
    
    /// оставшееся время задачи
    var remainingTime: TimeInterval? {
        guard let endTime = endTime,
              endTime >= startTime
        else {
            return nil
        }
        return Date().timeIntervalSince(startTime)
    }

    /// прошло ли время, отведенное на задачу
    var isExpired: Bool? {
        guard let endTime = endTime else {
            return nil
        }
        return Date() > endTime
    }
    
}

