//
//  Helper.swift
//
//  
//
import UIKit

enum Helper {
    
    static var safeAreaInsets: UIEdgeInsets {
        
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.view.safeAreaInsets ?? .zero
//        UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets ?? .zero
    }
}
