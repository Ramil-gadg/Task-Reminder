//
//  AuthInteractor.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 05.04.2022.
//  
//

import UIKit

enum AuthError: Error {
    case invalidData
    
    var localizedDescription: String {
        switch self {
        case .invalidData:
            return "iv_invalid_data".localized
        }
    }
}

final class AuthInteractor {
    
    unowned var presenter: AuthPresenter?
    
    func checkAuth(with login: String, password: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        let trueLogin = "test@mail.ru"
        let truePassword = "123456"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if login == trueLogin,
               password == truePassword {
                
                completion(.success("token123456"))
            } else {
                completion(.failure(.invalidData))
            }
        }
    }
    
    func login(with username: String, password: String) {
        checkAuth(
            with: username,
            password: password,
            completion: { [weak self] result in
                switch result {
                    
                case .success(let token):
                    self?.presenter?.onSuccess(with: token)
                case .failure(let error):
                    self?.presenter?.onFailer(with: error.localizedDescription)
                }
            }
        )
    }
}
