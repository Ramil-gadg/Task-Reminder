//
//  DoneTaskCellModel.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 10.04.2022.
//

import UIKit

class DoneTaskCellModel {
    
    let model: TaskModel
    
    private weak var delegate: DoneTaskCellModelDelegate?
    
    var id: String {
        model.id
    }
    
    var name: String? {
        "\("l_executor".localized): \(model.name)"
    }
    
    var task: String? {
        "\("l_task".localized): \(model.task)"
    }
    
    var doneTime: String? {
        "\("l_finished".localized): \(Formatter.getStringFromDateFormatter2(date: model.doneTime))"
    }
    
    init(with model: TaskModel, delegate: DoneTaskCellModelDelegate) {
        self.model = model
        self.delegate = delegate
    }
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DoneTaskCellModel.reuseIdentifier,
            for: indexPath
        ) as? DoneTaskTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: self)
        return cell
    }
    
    static var reuseIdentifier: String {
        String(describing: DoneTaskTableViewCell.self)
    }
    
    func doneBtnTapped() {
        delegate?.doneBtnTapped(with: model.id, name: model.name)
    }
}
