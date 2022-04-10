//
//  HomeFactory.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 26.03.2022.
//  
//

import Foundation

protocol HomeFactory {
    
    /// Главный экран
    func makeHomeView() -> HomeViewProtocol
    
    /// Добавление задачи
    func makeAddTask() -> AddTaskViewProtocol
    
    /// Редактирование задачи
    func makeEditTask(with input: EditTaskPresenter.Input) -> EditTaskViewProtocol
}
