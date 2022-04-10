//
//  MainCornersButton.swift

//

import UIKit

class MainCornersButton: ActionButton {
    
    enum Style {
        case blue
        case red
        
        var textColor: UIColor {
            switch self {
            case .blue, .red:
                return UIColor.white
            }
        }
        
        var borderColor: UIColor {
            switch self {
            case .blue:
                return UIColor.systemBlue
            case .red:
                return UIColor.systemRed
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .blue:
                return UIColor.systemBlue
            case .red:
                return UIColor.systemRed
            }
        }
        
        var tintColor: UIColor {
            .white
        }
    }
    
    private (set) var style: Style
    
    init(with title: String?, by style: Style, isMute: Bool = false) {
        self.style = style
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1.5
        self.alpha = isMute ? 0.5 : 1.0
        updateUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        style = .blue
        super.init(coder: coder)
    }
    
    func updateUI() {
        self.backgroundColor = style.backgroundColor
        self.layer.borderColor = style.borderColor.cgColor
        self.setTitleColor(style.textColor, for: .normal)
        self.tintColor = style.tintColor
    }
    
    func setStyle(style: Style) {
        self.style = style
        updateUI()
    }

}
