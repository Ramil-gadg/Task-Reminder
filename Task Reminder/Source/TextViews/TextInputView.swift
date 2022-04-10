//
//  TextInputView.swift
//
//

import UIKit

class TextInputView: BaseView {
    
    var isEditing = false
    var textEntered: ((String) -> Void)?
    
    private lazy var view: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var placeHolderLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        lbl.textColor = .darkGray
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var placeholderTopSmallLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lbl.textColor = .darkGray
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.autocapitalizationType = .none
        tv.keyboardType = .default
        tv.returnKeyType = .done
        tv.textContainer.lineFragmentPadding = 0
        tv.font = .systemFont(ofSize: 15, weight: .regular)
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    init(with text: String? = nil, placeholder: String) {
        super.init(frame: .zero)
    
        textView.text = text
        placeHolderLbl.text = placeholder
        placeholderTopSmallLbl.text = placeholder
        textView.delegate = self
        updatePlaceholderUI()
    }
    
    override func initUI() {
        addSubview(view)
        view.addSubview(stackView)
        view.addSubview(placeHolderLbl)
        stackView.addArrangedSubviews([placeholderTopSmallLbl, textView])
    
        addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                    action: #selector(becomeFirstResponder)))
    }
    
    override func initConstraints() {
        
        placeHolderLbl.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        placeHolderLbl.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        placeholderTopSmallLbl.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        placeholderTopSmallLbl.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)

        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            placeHolderLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            placeHolderLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            placeHolderLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHolderLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
        ])

    }
    
    func setText(text: String?) {
        textView.text = text
        updatePlaceholderUI()
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        textView.becomeFirstResponder()
    }
    
    private func updatePlaceholderUI() {
        let isPlaceholderHidden = isEditing || !textView.text!.isEmpty
        
        UIView.animate(withDuration: 0.15) {
            self.placeHolderLbl.alpha = isPlaceholderHidden ? 0.0 : 1.0
            self.placeholderTopSmallLbl.isHidden = !isPlaceholderHidden
            self.setNeedsLayout()
        }
    }
}

extension TextInputView: UITextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        
        guard text.contains("\n") == false else {
            textView.endEditing(true)
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textEntered?(textView.text ?? "")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        isEditing = true
        updatePlaceholderUI()
        textEntered?(textView.text ?? "")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        isEditing = false
        updatePlaceholderUI()
        textEntered?(textView.text ?? "")
    }
}
