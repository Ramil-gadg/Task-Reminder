//
//  TaskCellModel.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 30.03.2022.
//  
//

import UIKit

class TaskCellModel {
    
    let model: TaskModel
    
    private weak var delegate: TaskCellModelDelegate?
    
    var id: String {
        model.id
    }
    
    var name: String? {
        model.name
    }
    
    var task: String? {
        model.task
    }
    
    var startTime: Date {
        model.startTime
    }
    
    var endTime: Date? {
        model.endTime
    }
    
    var withTime: Bool {
        model.endTime != nil
    }
    
    var isExpired: Bool {
        if let endTime = model.endTime {
            return Date() > endTime
        } else {
            return false
        }
    }
    
    var allTimeToDo: TimeInterval {
        model.allTimeToDo ?? 1
    }
    
    var passedTime: TimeInterval {
        model.passedTime
    }
    
    var remainingTime: String? {
        
        "\("remaining".localized): \((allTimeToDo - passedTime).stringFromTimeInterval())"
    }
    
    var remainingCoef: Float {
        Float(passedTime/allTimeToDo)
    }
    
    init(with model: TaskModel, delegate: TaskCellModelDelegate) {
        self.model = model
        self.delegate = delegate
    }
    
    var cell: TaskTableViewCell?
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskCellModel.reuseIdentifier,
            for: indexPath
        ) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: self)
        self.cell = cell
        return cell
    }
    
    static var reuseIdentifier: String {
        String(describing: TaskTableViewCell.self)
    }
    
    func update() {
        cell?.update(with: self)
    }
    
    func doneBtnTapped() {
        delegate?.doneBtnTapped(with: model.id, name: model.name)
    }
}
