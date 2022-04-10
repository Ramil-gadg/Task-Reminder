//
//  UIViewController+Extension.swift
//
//  
//

import UIKit

extension UIViewController {

    var topbarHeight: CGFloat {

        view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0 +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
