//
//  BlockingActivityIndicator.swift
//  
//

import UIKit

final class BlockingActivityIndicator: UIView {
    private let activityIndicator: UIActivityIndicatorView
    
    var isShowKeybord = false
    
    override init(frame: CGRect) {
        
        self.activityIndicator = UIActivityIndicatorView(
            frame:
                CGRect(origin: .zero,
                       size: CGSize(width: 44, height: 44))
        )
        activityIndicator.color = .gray
        
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIWindow {
    func startAnimating() {
        DispatchQueue.main.async {
            guard !self.subviews.contains(where: { $0 is BlockingActivityIndicator }) else {
                return
            }
            let activityIndicator = BlockingActivityIndicator()
            activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            activityIndicator.frame = self.bounds
            
            UIView.transition(
                with: self,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: {
                    self.endEditing(true)
                    DispatchQueue.main.async {
                        self.addSubview(activityIndicator)
                    }
                }
            )
        }
    }
    
    func stopAnimating() {
        DispatchQueue.main.async {
            self.subviews.compactMap({ $0 as? BlockingActivityIndicator }).forEach({ existingView in
                UIView.transition(
                    with: self,
                    duration: 0.3,
                    options: .transitionCrossDissolve,
                    animations: {
                        DispatchQueue.main.async {
                            existingView.removeFromSuperview()
                        }
                    }
                )
            })
        }
    }
}
