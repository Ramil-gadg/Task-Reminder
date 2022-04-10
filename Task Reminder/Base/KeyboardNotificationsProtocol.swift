//
//  KeyboardNotificationsProtocol.swift
//  
//

import UIKit
import Foundation

protocol KeyboardNotifications: AnyObject {
    func registerForKeyboardNotifications()
    func keyboardWillChange(height: CGFloat)
}

extension KeyboardNotifications where Self: UIViewController {
    
    // swiftlint:disable discarded_notification_center_observer
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillChangeFrameNotification,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            self?.keyboardNotification(notification)
        }
        view.layoutIfNeeded()
    }
    
    func deregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func keyboardNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
            
            UIView.animate(
                withDuration: duration,
                delay: TimeInterval(0),
                options: animationCurve,
                animations: { [weak self] in
                    if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                        self?.keyboardWillChange(height: 0.0)
                    } else {
                        self?.keyboardWillChange(height: endFrame?.size.height ?? 0.0)
                    }
                    self?.view.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }
}
