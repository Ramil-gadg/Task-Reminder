//
//  SetPinCodeViewController.swift
//  delta-ohrana
//
//  Created by Sergey Nazarov on 19.01.2022.
//  
//

import UIKit

/**
 Установить пин-код
*/
class SetPinCodeViewController: BaseViewController, SetPinCodeAssemblable {

    var presenter: SetPinCodePresenterInput?
    
    var onCompletion: CompletionBlock?
    
    private let keyboardView = KeyboardView(isExit: false)
    private let pinCodeContainerView = UIView()
    private let pinCodeInputContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private let messageLabelPin = TaskPinMessageLabel()
    private let pinCodeInputViewTop = PinCodeInputView(title: "come_up_pin_code".localized)
    private let pinCodeInputViewBottom = PinCodeInputView(title: "repeat_pin_code".localized)

    private var pinCodeItem = PinCodeItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func initUI() {
        title = "t_pin_code".localized
        
        pinCodeContainerView.translatesAutoresizingMaskIntoConstraints = false
        pinCodeInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        pinCodeInputViewTop.translatesAutoresizingMaskIntoConstraints = false
        pinCodeInputViewBottom.translatesAutoresizingMaskIntoConstraints = false
        messageLabelPin.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubviews(keyboardView, pinCodeContainerView)

        pinCodeContainerView.addSubview(pinCodeInputContainerView)
        pinCodeInputContainerView.addArrangedSubviews([
            pinCodeInputViewTop,
            pinCodeInputViewBottom,
            messageLabelPin
        ])

        pinCodeInputViewBottom.isHidden = true
        pinCodeInputViewBottom.alpha = 0

        messageLabelPin.setTitle(with: .warning, by: "enter_pin_inof".localized)
    }
    
    override func initConstraints() {
        
        NSLayoutConstraint.activate([
            
            pinCodeContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topbarHeight),
            pinCodeContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pinCodeContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pinCodeContainerView.bottomAnchor.constraint(equalTo: keyboardView.topAnchor),
            
            pinCodeInputContainerView.centerXAnchor.constraint(equalTo: pinCodeContainerView.centerXAnchor),
            pinCodeInputContainerView.centerYAnchor.constraint(equalTo: pinCodeContainerView.centerYAnchor),
            pinCodeInputContainerView.leadingAnchor.constraint(equalTo: pinCodeContainerView.leadingAnchor, constant: 32),

            pinCodeInputViewTop.leadingAnchor.constraint(equalTo: pinCodeInputContainerView.leadingAnchor),
            pinCodeInputViewTop.trailingAnchor.constraint(equalTo: pinCodeInputContainerView.trailingAnchor),
            
            pinCodeInputViewBottom.leadingAnchor.constraint(equalTo: pinCodeInputContainerView.leadingAnchor),
            pinCodeInputViewBottom.trailingAnchor.constraint(equalTo: pinCodeInputContainerView.trailingAnchor),
            
            messageLabelPin.leadingAnchor.constraint(equalTo: pinCodeInputContainerView.leadingAnchor),
            messageLabelPin.trailingAnchor.constraint(equalTo: pinCodeInputContainerView.trailingAnchor),

            keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Helper.safeAreaInsets.bottom - 20),
            keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardView.heightAnchor.constraint(equalToConstant: 352)
        
        ])
    }
    
    override func initListeners() {

        keyboardView.onButton = { [weak self] number in
            guard let `self` = self else {
                return
            }
            
            switch number {
            case -1:
                let isRepeat = !self.pinCodeItem.pinCodeRepeat.isEmpty
                self.removePin(isRepeat: isRepeat)
                if isRepeat {
                    self.pinCodeInputViewBottom.removeLastSelected()
                } else {
                    self.pinCodeInputViewTop.removeLastSelected()
                }
            case -2:
                break
            default:
                let isRepeat = self.pinCodeItem.pinCode.count == 4
                self.addPin(number: number, isRepeat: isRepeat)
                if isRepeat {
                    self.pinCodeInputViewBottom.setSelectedPins(self.pinCodeItem.pinCodeRepeat.count)
                } else {
                    self.pinCodeInputViewTop.setSelectedPins(self.pinCodeItem.pinCode.count)
                }
            }
        }
    }
    
    private func addPin(number: Int, isRepeat: Bool) {
        if isRepeat {
            if pinCodeItem.pinCodeRepeat.count < 4 {
                pinCodeItem.pinCodeRepeat.append(number)
                messageLabelPin.isHidden = true
            }
            
            if pinCodeItem.pinCodeRepeat.count == 4 {
                if pinCodeItem.validate() {
                    presenter?.pinCodeDidSet(pinCodeItem: pinCodeItem)
                } else {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                    pinCodeInputViewTop.errorPins()
                    pinCodeInputViewBottom.errorPins()
                    pinCodeItem.clear()
                    
                    animateHideShow(
                        is: true,
                        withDuration: 0,
                        delay: 0,
                        onComplite: ({ [weak self] in
                            self?.messageLabelPin.setTitle(with: .error, by: "enter_pin_with_error".localized)
                            self?.messageLabelPin.isHidden = false
                        })
                    )
                }
            }
        } else {
            if self.pinCodeItem.pinCode.count < 4 {
                self.pinCodeItem.pinCode.append(number)
                if !self.pinCodeItem.pinCode.isEmpty && self.pinCodeItem.pinCode.count < 4 {
                    self.pinCodeInputViewTop.setSelectedPins(self.pinCodeItem.pinCode.count)
                }
            }
            animateHideShow(
                is: self.pinCodeItem.pinCode.count == 4 ? false : true,
                onComplite: ({ [weak self] in
                    guard let self = self else {
                        return
                    }
                    if self.pinCodeItem.pinCode.count < 4 {
                        if !self.pinCodeItem.pinCode.isEmpty && self.pinCodeItem.pinCode.count < 4 {
                            self.messageLabelPin.setTitle(with: .warning, by: "enter_pin_inof".localized)
                            self.messageLabelPin.isHidden = false
                        } else {
                            self.messageLabelPin.isHidden = true
                        }
                    } else {
                        self.messageLabelPin.isHidden = true
                    }
                })
            )
        }
    }
    
    private func removePin(isRepeat: Bool) {
        if isRepeat {
            if !pinCodeItem.pinCodeRepeat.isEmpty {
                pinCodeItem.pinCodeRepeat.removeLast()
            }
        } else {
            if !pinCodeItem.pinCode.isEmpty {
                pinCodeItem.pinCode.removeLast()
            }
        }
        
        animateHideShow(
            is: self.pinCodeItem.pinCode.count == 4 ? false : true,
            withDuration: 0,
            delay: 0,
            onComplite: ({ [weak self] in
                guard let self = self else {
                    return
                }
                
                if isRepeat == false, !self.pinCodeItem.pinCode.isEmpty {
                    self.messageLabelPin.isHidden = self.pinCodeItem.pinCode.isEmpty
                }
            })
        )
    }

    private func animateHideShow(is hide: Bool,
                                 withDuration: CGFloat = 0.15,
                                 delay: CGFloat = 0.3,
                                 onComplite: @escaping () -> Void) {
        self.keyboardView.isUserInteractionEnabled = false
        UIView.animate(
            withDuration: TimeInterval(withDuration),
            delay: TimeInterval(delay),
            animations: ({
                self.pinCodeInputViewBottom.alpha = hide ? 0 : 1.0
                self.pinCodeInputViewTop.alpha = hide ? 1.0 : 0
            }),
            completion: ({ _ in
                self.pinCodeInputViewBottom.isHidden = hide
                self.pinCodeInputViewTop.isHidden = !self.pinCodeInputViewBottom.isHidden
                self.keyboardView.isUserInteractionEnabled = true
                onComplite()
            })
        )
    }

    deinit {
        print("SetPinCodeViewController is deinit")
    }
}

// MARK: - SetPinCodePresenterOutput

extension SetPinCodeViewController {
    
// TODO: implement output presentation methods
    
}
