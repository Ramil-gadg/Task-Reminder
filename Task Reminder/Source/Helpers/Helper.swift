//
//  Helper.swift
//  delta-ohrana
//
//  Created by Sergey Nazarov on 12.01.2022.
//  
//
import UIKit

enum Helper {
    
    static var safeAreaInsets: UIEdgeInsets {
        UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets ?? .zero
    }
}
