//
//  DoneTasksViewProtocol.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 10.04.2022.
//  
//

import UIKit

protocol DoneTasksViewProtocol: BaseViewProtocol {
    
    var onCompletion: CompletionBlock? { get set }
    
}