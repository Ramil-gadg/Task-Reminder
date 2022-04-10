//
//  PinCodePresenter.swift
//  delta-ohrana
//
//  Created by Sergey Nazarov on 19.01.2022.
//  
//

import UIKit
import LocalAuthentication

protocol PinCodePresenterInput: AnyObject {
    func pinCodeDidSet(
        with pinCodeItem: PinCodeItem,
        didSetIncorrectPin: @escaping DidSetIncorrectPin,
        countAttemptZero: @escaping CountAttemptZero
    )
    
    func authByBiometry(didPinReceived: @escaping DidPinReceived)
    
    func exit()
}

protocol PinCodePresenterOutput: BasePresenterOutput {
    
    var presenter: PinCodePresenterInput? { get set }
    
    var onCompletion: (() -> Void)? { get set }
}

final class PinCodePresenter {

    weak var output: PinCodePresenterOutput?
    
    var interactor: PinCodeInteractor?
    
    private var countAttempt = 3
}

// MARK: - PinCodePresenterInput

extension PinCodePresenter: PinCodePresenterInput {
    func authByBiometry(didPinReceived: @escaping DidPinReceived) {
        let context = LAContext()
        
        // Read stored Token
        if let token = PinCodeAuth.getToken(context: context) {
            SessionManager.token = token
            print("TOKEN = \(token)")
            didPinReceived()
            countAttempt = 3
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.output?.onCompletion?()
            }
        }
    }
    
    func pinCodeDidSet(
        with pinCodeItem: PinCodeItem,
        didSetIncorrectPin: @escaping DidSetIncorrectPin,
        countAttemptZero: @escaping CountAttemptZero
    ) {
        let pinCodeString = pinCodeItem.pinCode.map({ String($0) }).joined()
       
        if let token = PinCodeAuth.getToken(pinCode: pinCodeString) {
            print("TOKEN = \(token)")
            SessionManager.token = token
            countAttempt = 3
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.output?.onCompletion?()
            }
        } else {
            didSetIncorrectPin()
            
            countAttempt -= 1
            if countAttempt == 0 {
                countAttemptZero()
            }
        }
    }
    
    func exit() {
        SessionManager.token = nil
        SessionManager.didSetPin = false
        output?.onCompletion?()

    }
}
