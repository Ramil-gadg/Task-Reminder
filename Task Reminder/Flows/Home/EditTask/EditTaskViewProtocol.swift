//
//  EditTaskViewProtocol.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 03.04.2022.
//  
//

import UIKit

protocol EditTaskViewProtocol: BaseViewProtocol {
    
    var onCompletion: CompletionBlock? { get set }
    
    var taskEdit: (() -> Void)? { get set }
    
}
