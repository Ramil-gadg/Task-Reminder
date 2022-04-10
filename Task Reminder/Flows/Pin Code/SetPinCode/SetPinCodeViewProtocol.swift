//
//  SetPinCodeViewProtocol.swift
//  delta-ohrana
//
//  Created by Sergey Nazarov on 19.01.2022.
//  
//

import UIKit

protocol SetPinCodeViewProtocol: BaseViewProtocol {
    
    var onCompletion: CompletionBlock? { get set }
    
}