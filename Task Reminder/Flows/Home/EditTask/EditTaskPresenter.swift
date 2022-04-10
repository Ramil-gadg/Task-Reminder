//
//  EditTaskPresenter.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 03.04.2022.
//  
//

import UIKit

protocol EditTaskPresenterInput: AnyObject {
    
    func onStart()
    func textEntered(fieldType: TaskFieldType, text: String)
    func onNext()
    func taskDone(with isDone: Bool)
    
}

protocol EditTaskPresenterOutput: BasePresenterOutput {
    
    var presenter: EditTaskPresenterInput? { get set }
    
    var taskEdit: (() -> Void)? { get set }
    
    func setTask(with task: TaskModel)
    func setButtonEnabled(enabled: Bool)
    
}

final class EditTaskPresenter {
    
    weak var output: EditTaskPresenterOutput?
    
    var interactor: EditTaskInteractor?
    
    private var input: Input
    
    init (with input: Input) {
        self.input = input
    }
    
    func onTaskChanghed() {
        output?.onAnimating(isStart: false)
        output?.taskEdit?()
    }
    
    func onFailure() {
        output?.onAnimating(isStart: false)
    }
}

private extension EditTaskPresenter {
    private func validate() {
        
        var enabled = false
        if !input.taskModel.name.isEmpty,
           !input.taskModel.task.isEmpty {
            
            enabled = true
        }
        
        output?.setButtonEnabled(enabled: enabled)
    }
}

// MARK: - EditTaskPresenterInput

extension EditTaskPresenter: EditTaskPresenterInput {
    
    func onStart() {
        output?.setTask(with: input.taskModel)
    }
    
    func textEntered(fieldType: TaskFieldType, text: String) {
        switch fieldType {
            
        case .name:
            input.taskModel.name = text
        case .task:
            input.taskModel.task = text
        case .endDate:
            input.taskModel.endTime = Formatter.getDateFromStringFormatter(dateStr: text)
        }
        
        validate()
    }
    
    func taskDone(with isDone: Bool) {
        input.taskModel.isDone = isDone
        input.taskModel.doneTime = isDone ? Date() : nil
    }
    
    func onNext() {
        var isValid = false
        
        if !input.taskModel.name.isEmpty,
           !input.taskModel.task.isEmpty {
            isValid = true
        }
        
        if isValid {
            
            output?.onAnimating(isStart: true)
            interactor?.editTask(with: input.taskModel)
        }
    }
}

extension EditTaskPresenter {
    struct Input {
        var taskModel: TaskModel
    }
}


