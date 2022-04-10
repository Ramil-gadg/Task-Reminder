//
//  TaskReminderCoordinators.swift
//  delta-ohrana
//
//  Created by Sergey Nazarov on 24.01.2022.
//

import Foundation

class TaskReminderCoordinators {
    
    var childCoordinators: [Coordinatable]
    
    init(childCoordinators: [Coordinatable]) {
        self.childCoordinators = childCoordinators
    }
}
