//
//  EditTaskViewController.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 03.04.2022.
//  
//

import UIKit

/**
 EditTask изменение задачи
 */
class EditTaskViewController: BaseViewController,
                              EditTaskAssemblable,
                              KeyboardNotifications,
                              WithNavigationItem {
    
    var presenter: EditTaskPresenterInput?
    
    var onCompletion: CompletionBlock?
    var taskEdit: (() -> Void)?
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 20
        sv.backgroundColor = .white
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var nameView = TextInputView(placeholder: "receiver_name".localized)
    
    private lazy var taskView = TextInputView(placeholder: "task_name".localized)
    
    
    private let taskDoneView = WithCheckBoxView(
        title: "t_task_done".localized,
        agreementState: false
    )
    
    private lazy var tf: InputPlainFieldView = {
        let tf = InputPlainFieldView()
        tf.placeholder = "task_end_time".localized
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 10
        tf.textAlignment = .center
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var editBtnButton = MainCornersButton(
        with: "b_edit_task".localized,
        by: .blue, isMute: true
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func initUI() {
        title = "t_edit_task".localized
        registerForKeyboardNotifications()
        hideKeyboardWhenTappedAround()
        nameView.becomeFirstResponder()
        
        tf.datePicker(target: self,
                      doneAction: #selector(endTaskDoneAction),
                      cancelAction: #selector(cancelAction),
                      datePickerMode: .dateAndTime)
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubviews([nameView, taskView, taskDoneView, tf, editBtnButton])
        presenter?.onStart()
    }
    
    override func initConstraints() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        editBtnButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:  40),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            nameView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            nameView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            
            taskView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            taskView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            
            taskDoneView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            taskDoneView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            
            tf.heightAnchor.constraint(equalToConstant: 54),
            tf.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            tf.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            
            editBtnButton.heightAnchor.constraint(equalToConstant: 54),
            editBtnButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            editBtnButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor)
            
        ])
    }
    
    override func initListeners() {
        
        navigationItem(set: .left(type: .back)) { [weak self] _ in
            self?.onCompletion?()
        }
        
        editBtnButton.touchUp = { [weak self] _ in
            self?.presenter?.onNext()
        }
        
        nameView.textEntered = { [weak self] text in
            self?.presenter?.textEntered(fieldType: .name, text: text)
        }
        
        taskView.textEntered = { [weak self] text in
            self?.presenter?.textEntered(fieldType: .task, text: text)
        }
        
        taskDoneView.agreementTouchUp = { [weak self] state in
            self?.presenter?.taskDone(with: state)
        }
        
        tf.textEntered = { [weak self] text in
            self?.presenter?.textEntered(fieldType: .endDate, text: text)
        }
    }
    
    deinit {
        deregisterForKeyboardNotifications()
        print("EditTaskViewController is deinit")
    }
    
    @objc
    func cancelAction() {
        view.endEditing(true)
    }
    
    @objc
    func endTaskDoneAction() {
        if let datePickerView = tf.inputView as? UIDatePicker {
            tf.text = Formatter.getStringFromDateFormatter(date: datePickerView.date)
            tf.resignFirstResponder()
        }
    }
    
    func keyboardWillChange(height: CGFloat) {
        
        let offset = height == 0 ? 0 : height
        
        scrollView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: offset,
            right: 0
        )
        
    }
}

// MARK: - EditTaskPresenterOutput

extension EditTaskViewController {
    
    func setTask(with task: TaskModel) {
        nameView.setText(text: task.name)
        taskView.setText(text: task.task)
        tf.text = Formatter.getStringFromDateFormatter(date: task.endTime)
    }

    func setButtonEnabled(enabled: Bool) {
        editBtnButton.alpha = enabled ? 1.0 : 0.5
    }
}
