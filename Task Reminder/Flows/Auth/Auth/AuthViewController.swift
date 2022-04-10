//
//  AuthViewController.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 05.04.2022.
//  
//

import UIKit

/**
 Auth экран авторизации
 */
class AuthViewController: BaseViewController,
                          AuthAssemblable,
                          WithNavigationItem,
                          KeyboardNotifications {
    
    var presenter: AuthPresenterInput?
    
    var onCompletion: CompletionBlock?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private let mainView = UIView()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let logoImg: UIImageView = {
        let img = UIImageView(image: UIImage(named: "done_image"))
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let emailTF: InputFieldView = {
        let tf: InputFieldView = .fromNib()
        tf.configure(with: .email)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let passwordTF: InputFieldView = {
        let tf: InputFieldView = .fromNib()
        tf.configure(with: .password, isClearAction: false)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let nextBtn = MainCornersButton(
        with: "b_next".localized,
        by: .blue,
        isMute: false
    )
    
    private var isEye = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        registerForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navController?.setNavigationBarHidden(false, animated: true)
        emailTF.becomeFirstResponder()
    }
    
    override func initUI() {
        view.addSubviews(scrollView)
        
        scrollView.addSubview(mainView)
        mainView.addSubviews(stackView)
        
        setIconForTextField()
        
        stackView.addArrangedSubviews([logoImg, emailTF, passwordTF, nextBtn])
        stackView.addSpacing(32, after: logoImg)
        stackView.addSpacing(24, after: emailTF)
        stackView.addSpacing(40, after: passwordTF)
        
    }
    
    override func initConstraints() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        nextBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            mainView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mainView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            stackView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: mainView.bottomAnchor),
            
            logoImg.heightAnchor.constraint(equalToConstant: 80),
            
            nextBtn.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    override func initListeners() {
        
        
        nextBtn.touchUp = { [weak self] _ in
            self?.presenter?.onNext()
        }
        
        emailTF.textEntered = { [weak self] text, type in
            self?.presenter?.textEntered(text: text, fieldType: type)
        }
        emailTF.shouldReturn = { [weak self] _ in
            self?.passwordTF.becomeFirstResponder()
            
        }
        
        passwordTF.actionField = { [weak self] in
            self?.isEye = !(self?.isEye ?? true)
            self?.setIconForTextField()
        }
        
        passwordTF.textEntered = { [weak self] text, type in
            self?.presenter?.textEntered(text: text, fieldType: type)
        }
        
        passwordTF.shouldReturn = { [weak self] _ in
            self?.presenter?.onNext()
        }
    }
    
    private func setIconForTextField() {
        passwordTF.setIconForAction(with: isEye ? UIImage(named: "eye_off") : UIImage(named: "eye_on"))
        passwordTF.changeSecureTextEntry(isSequre: !isEye)
    }
    
    func keyboardWillChange(height: CGFloat) {
        let margin: CGFloat = height == 0 ? 0 : height + 64
        scrollView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: margin,
            right: 0
        )
    }
    
    deinit {
        print("AuthViewController is deinit")
    }
}

// MARK: - AuthPresenterOutput

extension AuthViewController {
    func showError(message: String?, type: InputFieldView.InputFieldViewType) {
        switch type {
        case .email:
            self.emailTF.showErrorHint(message: message)
        case .password:
            self.passwordTF.showErrorHint(message: message)
        default:
            break
        }
    }
    
    func showCommonError(message: String) {
        self.emailTF.showErrorHint(message: message)
        self.passwordTF.showErrorHint(message: message)
    }
    
    func setButtonEnabled(_ enabled: Bool) {
        nextBtn.alpha = enabled ? 1.0 : 0.5
    }
}
