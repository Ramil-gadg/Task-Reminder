//
//  AuthFactory.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 05.04.2022.
//  
//

import Foundation

protocol AuthFactory {
    
    func makeAuthView() -> AuthViewProtocol
    
}
