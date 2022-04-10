//
//  InfoScreenViewController.swift
//
//
//

import UIKit
import CoreGraphics

enum ThemeDigitKeyView {
    case whiteBG
    
    var titleTextColor: UIColor {
        switch self {
        case .whiteBG:
            return .systemBlue
        }
    }
    
    var tintPinDelete: UIColor {
        switch self {
        case .whiteBG:
            return .systemBlue
        }
    }
    
    var circleColor: CGColor {
        switch self {
        case .whiteBG:
            return UIColor.systemBlue.cgColor
        }
    }
    
    var tintActionButton: UIColor {
        switch self {
        case .whiteBG:
            return UIColor.cyan
        }
    }
    
    var animateAction: UIColor {
        switch self {
        case .whiteBG:
            return UIColor.cyan.withAlphaComponent(0.2)
        }
    }
        
    var iconBiometry: UIImage? {
        switch BiometricAuth.supportedBiometry {
        case .available(.faceID):
            return UIImage(named: "icon_face_id")
        case .available(.touchID):
            return UIImage(named: "icon_touch_id")
        default: return nil
        }
    }
}

final class DigitKeyView: BaseView {
    
    var onButton: ((_ number: Int) -> Void)?
    
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let actionButton = ActionButton(type: .system)
    
    private let buttonSize = CGSize(width: 72, height: 72)
    private var number: Int
    
    private let themeDigit: ThemeDigitKeyView
    
    private let animation = CABasicAnimation(keyPath: "backgroundColor")
    
    private let isExit: Bool
    
    init(number: Int, with theme: ThemeDigitKeyView = .whiteBG, isExit: Bool) {
        self.number = number
        self.themeDigit = theme
        self.isExit = isExit
        super.init(frame: CGRect.zero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = buttonSize.width / 2
    }
    
    override func initUI() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false

        containerView.clipsToBounds = true
        containerView.addSubviews(imageView, actionButton)
        
        addSubview(containerView)
        
        if number < 0 {
            setButton(tag: number)
        } else {
            drawText(number: number)
        }
    }
    
    override func initConstraints() {
        
        NSLayoutConstraint.activate([
            
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: buttonSize.width),
            containerView.heightAnchor.constraint(equalToConstant: buttonSize.width),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            actionButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        
        ])
        
    }
    
    override func initListeners() {
        
        actionButton.touchDown = { _ in
            self.highlightButton(isPressed: true)
            self.onButton?(self.number)
        }
        
        actionButton.touchUp = { _ in
            self.highlightButton(isPressed: false)
        }
        
        actionButton.touchExit = { _ in
            self.highlightButton(isPressed: false)
        }
        
    }
    
    private func highlightButton(isPressed: Bool) {
        
        if number < 0 {
            return
        }
        
        if isPressed {
            animateOnAction(fromValue: UIColor.clear.cgColor, toValue: themeDigit.animateAction.cgColor)
        } else {
            animateOnAction(fromValue: themeDigit.animateAction.cgColor, toValue: UIColor.clear.cgColor)
        }
        
    }
    
    private func animateOnAction(fromValue: CGColor, toValue: CGColor) {
        self.containerView.backgroundColor = UIColor(cgColor: toValue)
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = 0.15
        self.containerView.layer.add(animation, forKey: nil)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.1)
        CATransaction.commit()
    }

    private func drawText(number: Int) {
        let renderer = UIGraphicsImageRenderer(size: buttonSize)

        let image = renderer.image { context in
            let roundView = UIView(frame: CGRect(x: 0, y: 0, width: buttonSize.width, height: buttonSize.height))
            roundView.layer.cornerRadius = buttonSize.width / 2
            roundView.layer.borderWidth = 1
            roundView.layer.borderColor = themeDigit.circleColor
            roundView.layer.render(in: context.cgContext)
            
            // Digit
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 35),
                .foregroundColor: themeDigit.titleTextColor,
                .paragraphStyle: paragraphStyle
            ]
            
            let attributedDigit = NSAttributedString(string: String(describing: number), attributes: attrs)
            
            attributedDigit.draw(
                with: CGRect(x: buttonSize.width / 2 - 10, y: 15, width: 20, height: 42),
                options: .usesLineFragmentOrigin,
                context: nil
            )
        }
        
        imageView.image = image
    }
    
    private func setButton(tag: Int) {
        imageView.isHidden = true
        actionButton.tintColor = themeDigit.tintActionButton
        
        switch tag {
        case ActionKeyboard.delete.number:
            actionButton.tintColor = themeDigit.tintPinDelete
            actionButton.setImage(UIImage(named: "icon_pin_delete"), for: .normal)
        case ActionKeyboard.biometry.number:
            actionButton.setImage(themeDigit.iconBiometry, for: .normal)
        case ActionKeyboard.exit.number:
            if isExit {
                actionButton.setTitle("b_forgot_code".localized, for: .normal)
                actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
                actionButton.setTitleColor(themeDigit.titleTextColor, for: .normal)
                actionButton.titleLabel?.numberOfLines = 2
                actionButton.titleLabel?.textAlignment = .center
            } else {
                actionButton.alpha = 0
                actionButton.isUserInteractionEnabled = false
            }
        default:
            break
        }
    }
    
    func changeBtnOnBiometry() {
        if number == ActionKeyboard.delete.number {
            if let iconBiometry = themeDigit.iconBiometry {
                actionButton.setImage(iconBiometry, for: .normal)
                number = ActionKeyboard.biometry.number
            } else {
                actionButton.tintColor = themeDigit.tintPinDelete
                actionButton.setImage(UIImage(named: "icon_pin_delete"), for: .normal)
                number = ActionKeyboard.delete.number
            }
        }
    }

    func changeBtnOnDelete() {
        if number == ActionKeyboard.biometry.number {
            actionButton.tintColor = themeDigit.tintPinDelete
            actionButton.setImage(UIImage(named: "icon_pin_delete"), for: .normal)
            number = ActionKeyboard.delete.number
        }
    }
}

