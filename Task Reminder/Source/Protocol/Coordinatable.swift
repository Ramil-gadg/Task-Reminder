//
//  Coordinatable.swift
//  delta-ohrana
//
//  Created by Sergey Nazarov on 11.01.2022.
//  
//

import UIKit

protocol Coordinatable: AnyObject {
    
    var router: Routable { get }
    
    func start()
    
}
