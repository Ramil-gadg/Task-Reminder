//
//  PinCodeViewController.swift
//
//  
//

import UIKit

/**
 PinCode авторизоваться
 */
class PinCodeViewController: BaseViewController, PinCodeAssemblable, WithNavigationItem {

    var presenter: PinCodePresenterInput?
    
    var onCompletion: CompletionBlock?
    var onCreatePinFlow: CompletionBlock?
    
    // UI
    private let logo: UIImageView = {
        let img = UIImageView(image: UIImage(named: "done_image"))
        return img
    }()
    
    private let pinCodeInputView = PinCodeInputView(title: "enter_pin".localized, with: .whiteBG)
    private let keyboardView = KeyboardView(with: .whiteBG, isExit: true)
    
    private var pinCodeItem = PinCodeItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        deleteOrBiometry()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.checkAuthByBiometry()
        }
    }
    
    override func initUI() {
        logo.translatesAutoresizingMaskIntoConstraints = false
        pinCodeInputView.translatesAutoresizingMaskIntoConstraints = false
        keyboardView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubviews(logo, pinCodeInputView, keyboardView)
    }
    
    override func initConstraints() {
        
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logo.heightAnchor.constraint(equalToConstant: 88),
            logo.widthAnchor.constraint(equalToConstant: 88),
            
            pinCodeInputView.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 54),
            pinCodeInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pinCodeInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
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
            case ActionKeyboard.delete.number:
                self.removePin()
                self.pinCodeInputView.removeLastSelected()
            case ActionKeyboard.biometry.number:
                self.checkAuthByBiometry()
            case ActionKeyboard.exit.number:
                self.exit()
            default:
                self.addPin(number: number)
            }
            
            self.deleteOrBiometry()
        }
    }

    deinit {
        print("PinCodeViewController is deinit")
    }
}

private extension PinCodeViewController {
    /**
     Поменять  действие и внешний вид кноки удалить/биометрия
     - Если устройство поддерживает биометрию и настроен вход по биометрии то
     - кнопка биометрии становится удалить когда пользователь ввел хотя бы один символ кода,
     - когда поле ввода пустое вместо кнопки удалить будет кнопка биометрии
     */
    func deleteOrBiometry() {
        if pinCodeItem.pinCode.isEmpty && SessionManager.didSetBiometry {
            keyboardView.changeTypeButton(on: .biometry)
        } else {
            keyboardView.changeTypeButton(on: .delete)
        }
    }
    
    /**
     Добавления нового символа к пинкоду
     - Добавляет когда символов меньше 4,
     - Когда добавили 4 символ сохраняем пин-код
     */
    func addPin(number: Int) {
        if pinCodeItem.pinCode.count < 4 {
            
            pinCodeItem.pinCode.append(number)
            pinCodeInputView.setSelectedPins(self.pinCodeItem.pinCode.count)
            
            if pinCodeItem.pinCode.count == 4 {
                presenter?.pinCodeDidSet(
                    with: pinCodeItem,
                    didSetIncorrectPin: {
                        [weak self] in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            self?.pinCodeInputView.errorPins()
                            self?.pinCodeItem.clear()
                            self?.deleteOrBiometry()
                        }
                    }, countAttemptZero: { [weak self] in
                        self?.exit()
                    }
                )
            }
        }
    }
    
    /**
     Удалить последний введеный символ
     */
    private func removePin() {
        if !pinCodeItem.pinCode.isEmpty {
            pinCodeItem.pinCode.removeLast()
        }
    }
    
    /**
     Авторизоваться по биометрии если возможно
     - Отрабатывает когда экран был загружен или была нажата кнопка
     */
    func checkAuthByBiometry() {
        if SessionManager.didSetBiometry {
            presenter?.authByBiometry(didPinReceived: { [weak self] in
                self?.fullInputPinCode()
                }
            )
        }
    }
    
    /**
     Закрашиваем кружки
     */
    func fullInputPinCode() {
        self.pinCodeItem.pinCode = [0, 0, 0, 0]
        pinCodeInputView.setSelectedPins(self.pinCodeItem.pinCode.count)
    }
    
    /**
     Удалить установленный пин-код и данные биометрии
     - При нажатии на кнопку выход
     */
    func exit() {
        presenter?.exit()
    }
}
