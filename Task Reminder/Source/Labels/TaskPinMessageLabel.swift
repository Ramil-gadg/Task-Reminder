//
//  TaskPinMessageLabel.swift
//
//

import UIKit

class TaskPinMessageLabel: UILabel {

    enum StyleMessage {
        case error
        case warning
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        initUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initUI()
    }
    
    func initUI() {
        self.font = .systemFont(ofSize: 15, weight: .regular)
        self.numberOfLines = 2
        self.textAlignment = .center
    }
    
    func setTitle(with style: StyleMessage, by text: String) {
        switch style {
        case .error:
            self.textColor = .systemRed
        case .warning:
            self.textColor = .systemGray2
        }
        self.text = text
    }
}
