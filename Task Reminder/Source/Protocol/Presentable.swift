//
//  Presentable.swift
//  delta-ohrana
//
//  Created by Sergey Nazarov on 11.01.2022.
//  
//

import UIKit

protocol Presentable {
    
    var toPresent: UIViewController? { get }
    
}

extension UIViewController: Presentable {
    
    var toPresent: UIViewController? {
        self
    }
}
