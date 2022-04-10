//
//  AddTaskViewProtocol.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 02.04.2022.
//  
//

import UIKit

protocol AddTaskViewProtocol: BaseViewProtocol {
    
    var onCompletion: CompletionBlock? { get set }
    
    var taskAdded: ((TaskModel) -> Void)? { get set }
}
