//
//  PinCodeAssembly.swift
//  delta-ohrana
//
//  Created by Sergey Nazarov on 19.01.2022.
//  
//

import UIKit

protocol PinCodeAssemblable: PinCodeViewProtocol, PinCodePresenterOutput {}

enum PinCodeAssembly {
    
    static func assembly(with output: PinCodePresenterOutput) {
        let interactor = PinCodeInteractor()
        let presenter = PinCodePresenter()
        
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.output = output
        output.presenter = presenter
    }
    
}
