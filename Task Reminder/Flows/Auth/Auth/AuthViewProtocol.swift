//
//  AuthViewProtocol.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 05.04.2022.
//  
//

import UIKit

protocol AuthViewProtocol: BaseViewProtocol {
    
    var onCompletion: CompletionBlock? { get set }
    
}