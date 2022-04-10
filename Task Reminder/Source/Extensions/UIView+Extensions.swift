//
//  UIView+Extensions.swift
//  delta-ohrana
//
//  Created by Sergey Nazarov on 11.01.2022.
//  
//

import UIKit

extension UIView {
    
    class func fromNib<T: UIView>() -> T {
        Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
}

extension UIView {
    
    public func addSubviews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
    
    func updateConstraint(_ attribute: NSLayoutConstraint.Attribute, to constant: CGFloat) {
        for constraint in constraints where constraint.firstAttribute == attribute {
            constraint.constant = constant
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         layer.mask = mask
     }
}
