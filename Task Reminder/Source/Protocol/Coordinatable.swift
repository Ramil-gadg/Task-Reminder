//
//  Coordinatable.swift
//
//
//

import UIKit

protocol Coordinatable: AnyObject {
    
    var router: Routable { get }
    
    func start()
    
}
