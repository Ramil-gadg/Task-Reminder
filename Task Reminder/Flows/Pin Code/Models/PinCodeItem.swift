//
//  PinCodeItem.swift
//  delta-ohrana
//
//  Created by Sergey Nazarov on 20.01.2022.
//

import Foundation

struct PinCodeItem {
    
    var pinCode = [Int]()
    var pinCodeRepeat = [Int]()
    var pinCodeOld = [Int]()
    
    func validate() -> Bool {
        pinCode == pinCodeRepeat
    }
    
    mutating func clear() {
        pinCodeOld.removeAll()
        pinCode.removeAll()
        pinCodeRepeat.removeAll()
    }
}
