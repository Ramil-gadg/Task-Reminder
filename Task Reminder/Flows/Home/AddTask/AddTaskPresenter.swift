//
//  AddTaskPresenter.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 02.04.2022.
//  
//

import UIKit

protocol AddTaskPresenterInput: AnyObject {
    
    func textEntered(fieldType: TaskFieldType, text: String)
    func onNext()
}

protocol AddTaskPresenterOutput: BasePresenterOutput {
    
    var presenter: AddTaskPresenterInput? { get set }
    func taskAdded(with task: TaskModel)
    
    func setButtonEnabled(enabled: Bool)

}

final class AddTaskPresenter {

    weak var output: AddTaskPresenterOutput?
    
    var interactor: AddTaskInteractor?
    
    private var name: String?
    private var task: String?
    private var endTime: Date?
    
    func onSaveTaskSuccess(with task: TaskModel) {
        output?.taskAdded(with: task)
    }
    
    func onFailure() {
        print("task didn't added")
    }
}

private extension AddTaskPresenter {
    private func validate() {
        
        var enabled = false
        if let name = name,
           let task = task,
           !name.isEmpty,
           !task.isEmpty {
            
            enabled = true
        }
        
        output?.setButtonEnabled(enabled: enabled)
    }
}

// MARK: - AddTaskPresenterInput

extension AddTaskPresenter: AddTaskPresenterInput {
    
    func textEntered(fieldType: TaskFieldType, text: String) {
        switch fieldType {
            
        case .name:
            name = text
        case .task:
            task = text
        case .endDate:
            endTime = Formatter.getDateFromStringFormatter(dateStr: text)
        }
        
        validate()
    }
    
    func onNext() {
        var isValid = false
        
        if let name = name,
           let task = task,
           !name.isEmpty,
           !task.isEmpty {
            isValid = true
        }
        
        if isValid {
            
            let task = TaskModel(
                with: name!,
                task: task!,
                endTime: endTime
            )
            interactor?.saveTask(taskModel: task)
        }
    }
}
