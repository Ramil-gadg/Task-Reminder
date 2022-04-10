//
//  DoneTaskCellModelDelegate.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 10.04.2022.
//

import Foundation

protocol DoneTaskCellModelDelegate: AnyObject {
    func doneBtnTapped(with id: String, name: String)
}
