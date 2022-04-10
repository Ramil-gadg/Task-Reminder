//
//  PinCodeViewProtocol.swift
//  delta-ohrana
//
//  Created by Sergey Nazarov on 19.01.2022.
//  
//

import UIKit

protocol PinCodeViewProtocol: BaseViewProtocol {
    
    var onCompletion: CompletionBlock? { get set }
    var onCreatePinFlow: CompletionBlock? { get set }
    
}
