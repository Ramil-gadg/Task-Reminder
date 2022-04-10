//
//  InputFieldView.swift
//
//

import UIKit

class InputFieldView: BaseView {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var titleLbl: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var infoView: UIView!
    @IBOutlet private weak var actionButton: ActionButton!
    @IBOutlet private weak var descriptLbl: UILabel!
    @IBOutlet private weak var textFContainerView: UIView!
    
    private var currentType: InputFieldViewType?
    private var isEditing = false
    private var isClearAction = false
    
    var actionField: CompletionBlock?
    var textEntered: ((String, InputFieldViewType?) -> Void)?
    var shouldReturn: ((InputFieldViewType?) -> Void)?
    
    enum InputFieldViewType {
        case text
        case email
        case password
        
        var placeholder: String? {
            switch self {
            case .text:
                return nil
            case .email:
                return "iv_email".localized
            case .password:
                return "iv_password".localized
            }
        }
        
        var title: String? {
            switch self {
            case .text:
                return nil
            case .email:
                return "iv_email".localized
            case .password:
                return "iv_password".localized

            }
        }
    }
    
    var isDisabel = true {
        willSet(val) {
            self.textField.isUserInteractionEnabled = !val
        }
    }
    
    override func initUI() {
        
        textField.delegate = self
        textField.font = UIFont.systemFont(ofSize: 15)
        
        titleLbl.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        textFContainerView.layer.borderColor = UIColor.gray.cgColor
        textFContainerView.layer.cornerRadius = 5
        textFContainerView.layer.borderWidth = 1
        
        descriptLbl.isHidden = true
                
        addGestureRecognizer(
            UITapGestureRecognizer(target: self,
                                   action: #selector(becomeFirstResponder))
        )
    }
    
    override func initListeners() {
        actionButton.touchUp = { [weak self] _ in
            if self?.isClearAction ?? false {
                self?.clear()
            } else {
                self?.actionField?()
            }
        }
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
    
    func configure(with type: InputFieldViewType,
                   tfText: String? = nil,
                   title: String? = nil,
                   descript: String? = nil,
                   placeholder: String? = nil,
                   isClearAction: Bool = true) {
        currentType = type
        self.isClearAction = isClearAction
        
        stackView.addSpacing(4, after: titleLbl)
        titleLbl.text = title ?? type.title
        descriptLbl.text = descript
        
        actionButton.tintColor = UIColor.gray
        actionButton.setTitle("", for: .normal)
        
        textField.placeholder = placeholder ?? type.placeholder
        textField.borderStyle = .none
        textField.isSecureTextEntry = false
        textField.autocapitalizationType = .none
        textField.keyboardType = .default
        textField.text = tfText
        
        hideInfoView(true)
        
        switch type {
        case .text:
            textField.textContentType = .familyName
        case .email:
            textField.textContentType = .emailAddress
            textField.keyboardType = .emailAddress
        case .password:
            textField.isSecureTextEntry = true
            hideInfoView(false)
        }
    }
    
    func hideInfoView(_ show: Bool) {
        infoView.isHidden = show
    }
    
    func setIconForAction(with icon: UIImage?) {
        actionButton.setImage(icon, for: .normal)
    }
    
    func showErrorHint(message: String?) {
        descriptLbl.text = message
        
        DispatchQueue.main.async {
            
            self.textFContainerView.layer.borderColor = message == nil
            ? self.isEditing ? UIColor.black.cgColor : UIColor.gray.cgColor
            : UIColor.red.cgColor
            self.descriptLbl.isHidden = message == nil
        }
    }
    
    func clear() {
        textField.text = ""
        textEntered?(textField.text ?? "", currentType)
        if isClearAction {
            infoView.isHidden = true
        }
    }
    
    func changeSecureTextEntry(isSequre: Bool) {
        self.textField.isSecureTextEntry = isSequre
    }
}

extension InputFieldView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        isEditing = true
        
        if textField.isSecureTextEntry {
            textField.text = ""
        }
        self.textEntered?(textField.text ?? "", currentType)
        self.showErrorHint(message: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isEditing = false
        
        self.textFContainerView.layer.borderColor = UIColor.gray.cgColor
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        self.showErrorHint(message: nil)
        guard let text = textField.text as NSString? else {
            return false
        }
        
        let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
        
        if !txtAfterUpdate.isEmpty {
            if isClearAction {
                infoView.isHidden = false
            }
        } else {
            if isClearAction {
                infoView.isHidden = true
            }
        }
        
        self.textEntered?(txtAfterUpdate, currentType)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shouldReturn?(currentType)
        return true
    }
}

