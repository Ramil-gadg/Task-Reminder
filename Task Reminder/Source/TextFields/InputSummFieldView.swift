//
//  InputPlainFieldView.swift
//
//

import UIKit

class InputPlainFieldView: UITextField {
    
    var textEntered: ((String) -> Void)?
    
    init() {

        super.init(frame: .zero)
        initUI()
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initUI() {
        self.delegate = self
        self.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        self.tintColor = .blue
    }
}

extension InputPlainFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textEntered?(textField.text ?? "")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textEntered?(textField.text ?? "")
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        
        
        self.textEntered?(textField.text ?? "")
        return false
        
    }
    
}
