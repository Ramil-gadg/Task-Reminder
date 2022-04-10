//
//  UIViewController+Extension.swift
//
//  
//

import UIKit

extension UIViewController {

    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */

    var topbarHeight: CGFloat {
//        let height = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

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
