//
//  PinCodeFactory.swift
//  delta-ohrana
//
//  Created by Sergey Nazarov on 19.01.2022.
//  
//

import Foundation

protocol PinCodeFactory {
    
    /// Авторизация по пин-коду
    func makePinCodeView() -> PinCodeViewProtocol

    /// Создать пин-код
    func makeSetPinCode(with input: SetPinCodePresenter.Input) -> SetPinCodeViewProtocol
}
