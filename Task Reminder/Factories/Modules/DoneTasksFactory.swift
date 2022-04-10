//
//  DoneTasksFactory.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 10.04.2022.
//  
//

import Foundation

protocol DoneTasksFactory {
    
    /// Экран чс выполненными заданиями
    func makeDoneTasksView() -> DoneTasksViewProtocol
    
}
