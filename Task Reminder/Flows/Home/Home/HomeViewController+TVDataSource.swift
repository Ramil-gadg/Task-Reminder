//
//  HomeViewController+TVDataSource.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 30.03.2022.
//

import UIKit

extension HomeViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        tasks.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let taskCellModel = tasks[indexPath.row]
        return taskCellModel.cellForTableView(tableView: tableView,
                                              atIndexPath: indexPath)
    }
    
    func tableView(
        _ tableView: UITableView,
        canEditRowAt indexPath: IndexPath
    ) -> Bool {
        return true
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            
            presenter?.onDeleteTask(with: task.id)
        }
    }
    
}

