//
//  UIStackView+Extension.swift
//
//

import UIKit
import Foundation

extension UIStackView {
    
    func addArrangedSubviews(_ views: [UIView]) {
        for v in views {
            self.addArrangedSubview(v)
        }
    }

    func addSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) {
        let index = arrangedSubviews.firstIndex(of: arrangedSubview)

        if let index = index, arrangedSubviews.count > (index + 1), arrangedSubviews[index + 1].accessibilityIdentifier == "spacer" {

            arrangedSubviews[index + 1].updateConstraint(axis == .horizontal ? .width : .height, to: spacing)
        } else {
            let separatorView = UIView(frame: .zero)
            separatorView.accessibilityIdentifier = "spacer"
            separatorView.translatesAutoresizingMaskIntoConstraints = false

            switch axis {
            case .horizontal:
                separatorView.widthAnchor.constraint(equalToConstant: spacing).isActive = true
            case .vertical:
                separatorView.heightAnchor.constraint(equalToConstant: spacing).isActive = true
            @unknown default:
                return
            }
            if let index = index {
                insertArrangedSubview(separatorView, at: index + 1)
            }
        }
    }

}
