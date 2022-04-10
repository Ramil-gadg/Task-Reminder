//
//  PinCodeFactory.swift
//
//
//

import Foundation

protocol PinCodeFactory {
    
    /// Авторизация по пин-коду
    func makePinCodeView() -> PinCodeViewProtocol
    
    /// Создать пин-код
    func makeSetPinCode(with input: SetPinCodePresenter.Input) -> SetPinCodeViewProtocol
}
