//
//  AuthFactory.swift
//
//
//

import Foundation

protocol AuthFactory {
    
    func makeAuthView() -> AuthViewProtocol
    
}
