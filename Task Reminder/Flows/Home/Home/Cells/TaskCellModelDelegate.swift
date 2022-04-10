//
//  TaskCellModelDelegate.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 09.04.2022.
//

import Foundation

protocol TaskCellModelDelegate: AnyObject {
    
    func doneBtnTapped(with id: String, name: String)
}
