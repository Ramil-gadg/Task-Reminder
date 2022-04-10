//
//  AgreementView.swift
//
//

import UIKit

class WithCheckBoxView: BaseView {
    
    var agreementTouchUp: ((Bool) -> Void)?
    
    private let action: ActionButton = {
        let action = ActionButton()
        action.backgroundColor = .clear
        action.contentHorizontalAlignment = .center
        action.translatesAutoresizingMaskIntoConstraints = false
        return action
    }()
    
    private let title: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .regular)
        lbl.textColor = UIColor.black
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        lbl.isUserInteractionEnabled = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private (set) var agreementState = false {
        didSet {
            let image = agreementState ?
            UIImage(named: "ic_checkbox_on") :
            UIImage(named: "ic_checkbox_off")
            action.setImage(image, for: .normal)
        }
    }

    init(title: String,
         agreementState: Bool
    ) {
        self.title.text = title
        super.init(frame: .zero)
        
        let image = agreementState ?
        UIImage(named: "ic_checkbox_on") :
        UIImage(named: "ic_checkbox_off")
        action.setImage(image, for: .normal)

    }
    
    override func initUI() {
        super.initUI()
        
        addSubviews(title, action)
    }
    
    override func initConstraints() {
        
        NSLayoutConstraint.activate([
            action.topAnchor.constraint(equalTo: self.topAnchor),
            action.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            action.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            action.heightAnchor.constraint(equalToConstant: 24),
            action.widthAnchor.constraint(equalToConstant: 24),
            
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            title.leadingAnchor.constraint(equalTo: action.trailingAnchor, constant: 16),
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            
        ])
        
    }
    
    override func initListeners() {
        action.touchUp = { [weak self] _ in
            guard let self = self else {
                return
            }
            self.agreementState = !self.agreementState
            self.agreementTouchUp?(self.agreementState)
        }
    }
    
    func setButtonEnableState(with state: Bool) {
        self.action.isEnabled = state
    }
    
    func changeAgreementState(with state: Bool) {
        self.agreementState = state
    }
    
}
