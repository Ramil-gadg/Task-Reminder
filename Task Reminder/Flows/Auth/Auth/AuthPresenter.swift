//
//  AuthPresenter.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 05.04.2022.
//  
//

import UIKit

protocol AuthPresenterInput: AnyObject {
    
    func onNext()
    func textEntered(text: String, fieldType: InputFieldView.InputFieldViewType?)
}

protocol AuthPresenterOutput: BasePresenterOutput {
    
    var presenter: AuthPresenterInput? { get set }
    
    var onCompletion: CompletionBlock? { get set }
    func setButtonEnabled(_ enabled: Bool)
    func showError(message: String?, type: InputFieldView.InputFieldViewType)
    func showCommonError(message: String)
    
}

final class AuthPresenter {

    weak var output: AuthPresenterOutput?
    
    var interactor: AuthInteractor?
    
    private var email: String?
    private var password: String?
    
    func onSuccess(with token: String) {
        SessionManager.token = token
        output?.onAnimating(isStart: false)
        output?.showQuetionDialogQuetion(dialogModel: DialogModel(
            title: "alert_t_pin_code".localized,
            message: "alert_m_use_pin_code".localized,
            yesTitle: "alert_a_yes".localized,
            noTitle: "alert_a_no".localized,
            onYes: {
                SessionManager.skipCreatePin = false
                self.output?.onCompletion?()
            }, onNo: {
                SessionManager.skipCreatePin = true
                self.output?.onCompletion?()
            }))
            
    }

    func onFailer(with message: String) {
        output?.onAnimating(isStart: false)
        output?.showCommonError(message: message)
    }
}

private extension AuthPresenter {
    private func validate() {
        var isValid = false
         
        if (password?.count ?? 0 > 4) == true,
           email?.isValidEmail == true {
            isValid = true
        }
        
        output?.setButtonEnabled(isValid)
    }
}

// MARK: - AuthPresenterInput

extension AuthPresenter: AuthPresenterInput {
    func onNext() {
        var isValid = true
        
        if email?.isValidEmail == false {
            output?.showError(message: "iv_invalid_data_format".localized, type: .email)
            isValid = false
        }
        
        if password?.count ?? 0 <= 4 {
            output?.showError(message: "iv_invalid_password".localized, type: .password)
            isValid = false
        }
        
        if isValid {
            output?.onAnimating(isStart: true)
            interactor?.login(with: email ?? "", password: password ?? "")

        }
    }
    
    func textEntered(text: String, fieldType: InputFieldView.InputFieldViewType?) {
        guard let fieldType = fieldType else {
            return
        }
        switch fieldType {
        case .email:
            self.email = text.trimmed
        case .password:
            self.password = text
        default:
            break
        }
        validate()
    }

}
