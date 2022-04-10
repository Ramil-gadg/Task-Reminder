//
//  SetPinCodePresenter.swift
//  delta-ohrana
//
//  Created by Sergey Nazarov on 19.01.2022.
//  
//

import UIKit
import LocalAuthentication

protocol SetPinCodePresenterInput: AnyObject {
    func pinCodeDidSet(pinCodeItem: PinCodeItem)
}

protocol SetPinCodePresenterOutput: BasePresenterOutput {
    
    var presenter: SetPinCodePresenterInput? { get set }
    
    var onCompletion: (() -> Void)? { get set }
}

final class SetPinCodePresenter {

    weak var output: SetPinCodePresenterOutput?
    
    var interactor: SetPinCodeInteractor?
    
    private var deviceToken: String?
    private let input: Input
    
    init(with input: Input) {
        self.input = input
    }
}

private extension SetPinCodePresenter {
    func initBeometry(win pinCode: String) {
        // сохрянем пин код
        self.storedToken(with: pinCode, by: input.token)
        
        if let biometry = BiometricAuth.supportedBiometry.biometry {
            output?.showQuetionDialogQuetion(
                dialogModel: DialogModel(
                    title: "title_biometry".localized,
                    message: "message_biometry".localized + " \(biometry.rawValue)?",
                    yesTitle: "alert_a_yes".localized,
                    noTitle: "alert_a_no".localized,
                    onYes: ({ [weak self] in
                        self?.setupBiometry(complete: { [weak self] in
                            DispatchQueue.main.async {
                                self?.output?.onCompletion?()
                            }
                        })
                    }), onNo: ({ [weak self] in
                        SessionManager.didSetBiometry = false
                        DispatchQueue.main.async {
                            self?.output?.onCompletion?()
                        }
                    })
                )
            )
        } else {
            SessionManager.didSetBiometry = false
            DispatchQueue.main.async {
                self.output?.onCompletion?()
            }
        }
    }
    
    func setupBiometry(complete: @escaping (() -> Void) ) {
        storedTokenWithBiometry(by: input.token) { status in
            SessionManager.didSetBiometry = status
            complete()
        }
    }
    
    private func storedTokenWithBiometry(by deviceToken: String, callback: @escaping (Bool) -> Void) {
        switch BiometricAuth.supportedBiometry {
        case .available:

            let context = LAContext()

            context.evaluatePolicy(
                .deviceOwnerAuthentication,
                localizedReason: "Needs Biometric Auth",
                reply: { success, _ -> Void in
                    if success {
                        // 1. Configure biometric public/prive keys
                        PinCodeAuth.configureForBiometric()
                        // 2. Store token in Apple Enclave
                        if PinCodeAuth.storeTokenWithBiometric(token: deviceToken) {
                            print("Token stored successfully")
                        }
                    }
                    callback(success)
                }
            )
            
        default:
            callback(false)
        }
    }
    
    private func storedToken(with pinCode: String, by deviceToken: String) {
        // 1. Store token with pinCode
        if PinCodeAuth.storeTokenWith(pinCode: pinCode, token: deviceToken) {
            SessionManager.didSetPin = true
        } else {
            SessionManager.didSetPin = false
            output?.showErrorDialog(
                title: "alert_t_error".localized,
                message: "alert_m_dont_create_pin_code".localized,
                onButton: { [weak self] in
                    SessionManager.skipCreatePin = true
                    self?.output?.onCompletion?()
                }
            )
        }
    }
}

// MARK: - SetPinCodePresenterInput

extension SetPinCodePresenter: SetPinCodePresenterInput {
    func pinCodeDidSet(pinCodeItem: PinCodeItem) {
        let pinCodeString = pinCodeItem.pinCode.map({ String($0) }).joined()
        initBeometry(win: pinCodeString)
    }
}

extension SetPinCodePresenter {
    struct Input {
        var token: String
    }
}
