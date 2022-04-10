//
//  HomeFactory.swift
//
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
