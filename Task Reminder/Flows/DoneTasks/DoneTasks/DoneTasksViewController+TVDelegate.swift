//
//  DoneTasksViewController+TVDelegate.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 10.04.2022.
//

import UIKit

extension DoneTasksViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 0.0001
    }
}
