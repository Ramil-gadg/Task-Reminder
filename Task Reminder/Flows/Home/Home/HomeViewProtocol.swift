//
//  HomeViewProtocol.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 26.03.2022.
//  
//

import UIKit

protocol HomeViewProtocol: BaseViewProtocol, AddTaskProtocol, EditTaskProtocol {
    
    var onCompletion: CompletionBlock? { get set }
    
    /// Добавление задачи
    var onAddTask: CompletionBlock? { get set }
    
    /// Изменение задачи
    var onEditTask: ((TaskModel) -> Void)? { get set }
    
}

protocol AddTaskProtocol: AnyObject, StartTimer {
    
    func taskAdded(with task: TaskModel)
}

protocol EditTaskProtocol: AnyObject, StartTimer {
    
    func taskEdit()
}

protocol StartTimer {
    
    func startTimer()
}
