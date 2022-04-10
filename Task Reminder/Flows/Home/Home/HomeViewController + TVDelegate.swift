//
//  HomeViewController + TVDelegate.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 30.03.2022.
//

import UIKit

extension HomeViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 0.0001
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
            stopTimer()
            let task = tasks[indexPath.row]
            onEditTask?(task.model)
        }
}
