//
//  SetPinCodeAssembly.swift
//  delta-ohrana
//
//  Created by Sergey Nazarov on 19.01.2022.
//  
//

import UIKit

protocol SetPinCodeAssemblable: SetPinCodeViewProtocol, SetPinCodePresenterOutput {}

enum SetPinCodeAssembly {
    
    static func assembly(with output: SetPinCodePresenterOutput,
                         by input: SetPinCodePresenter.Input) {
        let interactor = SetPinCodeInteractor()
        let presenter = SetPinCodePresenter(with: input)
        
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.output = output
        output.presenter = presenter
    }
    
}
