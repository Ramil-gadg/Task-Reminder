//
//  InfoScreenViewController.swift
//
//
//

import UIKit

enum ThemePinCode {
    case whiteBG
    
    var titleTextColor: UIColor {
        switch self {
        case .whiteBG:
            return UIColor.white
        }
    }
    
    var dotImg: UIImage? {
        switch self {
        case .whiteBG:
            return UIImage(named: "pin_not_selected")
        }
    }
    
    var highlightedImage: UIImage? {
        switch self {
        case .whiteBG:
            return UIImage(named: "pin_selected")
        }
    }
    
}

final class PinCodeInputView: BaseView {
    
    private let themePinCode: ThemePinCode
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let pinStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private var pins = [UIImageView]()
    
    var title: String? {
        willSet(title) {
            self.titleLabel.text = title
        }
    }
    
    init(title: String,
         with theme: ThemePinCode = .whiteBG
    ) {
        self.themePinCode = theme
        
        super.init(frame: CGRect.zero)
        titleLabel.text = title
    }
    
    override func initUI() {
        for _ in 0...3 {
            let imageView = UIImageView(
                image: themePinCode.dotImg,
                highlightedImage: themePinCode.highlightedImage
            )
            imageView.translatesAutoresizingMaskIntoConstraints = false
            pins.append(imageView)
        }
        pinStackView.addArrangedSubviews(pins)

        addSubviews(titleLabel, pinStackView)
    }
    
    override func initConstraints() {
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: pinStackView.topAnchor, constant: -16),
            
            pinStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pinStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        
        ])
    }
    
    func setSelectedPins(_ countPins: Int) {
        if countPins == 0 {
            return
        }
        for index in 0...countPins - 1 {
            if index == countPins - 1 {
                UIView.animate(withDuration: 0.1) {
                    self.pins[index].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                } completion: { _ in
                    UIView.animate(withDuration: 0.1) {
                        self.pins[index].transform = CGAffineTransform(scaleX: 1, y: 1)
                    }
                }
            }
            pins[index].isHighlighted = true
        }
    }
    
    func removeLastSelected() {
        pins.last(where: { $0.isHighlighted })?.isHighlighted = false
    }
    
    func removeAllSelected() {
        pins.forEach({ $0.isHighlighted = false })
    }
    
    func errorPins() {
        
        CATransaction.begin()
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.duration = 1
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        CATransaction.commit()
        
        pinStackView.layer.add(animation, forKey: "shake")
        pins.forEach({ $0.isHighlighted = false })
    }
}
