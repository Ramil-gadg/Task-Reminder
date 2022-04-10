//
//  TaskReminderCoordinators.swift
//
//

import Foundation

class TaskReminderCoordinators {
    
    var childCoordinators: [Coordinatable]
    
    init(childCoordinators: [Coordinatable]) {
        self.childCoordinators = childCoordinators
    }
}
