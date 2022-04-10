//
//  AddTaskViewController.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 02.04.2022.
//  
//

import UIKit

/**
 AddTask добавление задачи
 */
class AddTaskViewController: BaseViewController,
                             AddTaskAssemblable,
                             KeyboardNotifications,
                             WithNavigationItem {
    
    var presenter: AddTaskPresenterInput?
    
    var onCompletion: CompletionBlock?
    var taskAdded: ((TaskModel) -> Void)?
    
    private var isFullScreen: Bool = false
    private let defaultHeight: CGFloat = 280
    private var maximumContainerHeight: CGFloat = 100
    private var currentTopConstraint: CGFloat = 0
    private var maxDimmedAlpha = 0.7
    private var containerViewConstraintBottom: NSLayoutConstraint?
    private var containerViewConstraintTop: NSLayoutConstraint?
    private lazy var panGesture = UIPanGestureRecognizer(
        target: self,
        action: #selector(self.handlePanAction(gesture:))
    )
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var topGestureLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var topGreyLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameView = TextInputView(placeholder: "receiver_name".localized)
    
    private lazy var taskView = TextInputView(placeholder: "task_name".localized)
    
    private lazy var tf: InputPlainFieldView = {
        let tf = InputPlainFieldView()
        tf.placeholder = "task_end_time".localized
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 10
        tf.textAlignment = .center
        return tf
    }()
    
    private lazy var addBtnButton = MainCornersButton(with: "b_add_task".localized,
                                                      by: .blue, isMute: true)
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameView.becomeFirstResponder()
        animateShowDimmedView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 16.0)
    }
    
    override func initUI() {
        title = "t_add_task".localized
        tf.isHidden = true
        registerForKeyboardNotifications()
        setupGestures()
        
        
        tf.datePicker(target: self,
                      doneAction: #selector(endTaskDoneAction),
                      cancelAction: #selector(cancelAction),
                      datePickerMode: .dateAndTime)
        
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        containerView.addSubviews(topGreyLineView, scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubviews([nameView, taskView, tf, addBtnButton])
    }
    
    override func initConstraints() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addBtnButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerViewConstraintTop = containerView.topAnchor.constraint(
            equalTo: view.topAnchor, constant: view.frame.size.height
        )
        
        containerViewConstraintBottom = containerView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor
        )
        
        let scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        scrollViewBottomConstraint.priority = .defaultHigh
        
        
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerViewConstraintTop!,
            containerViewConstraintBottom!,
            
            topGreyLineView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            topGreyLineView.heightAnchor.constraint(equalToConstant: 8),
            topGreyLineView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            topGreyLineView.widthAnchor.constraint(equalToConstant: 46),
            
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scrollView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            scrollView.topAnchor.constraint(equalTo: topGreyLineView.topAnchor, constant: 24),
            scrollViewBottomConstraint,
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            nameView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            nameView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            
            taskView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            taskView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            
            tf.heightAnchor.constraint(equalToConstant: 54),
            tf.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            tf.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            
            addBtnButton.heightAnchor.constraint(equalToConstant: 54),
            addBtnButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            addBtnButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor)
            
        ])
    }
    
    override func initListeners() {
        
        navigationItem(set: .left(type: .close)) { [weak self] _ in
            self?.onCompletion?()
        }
        
        nameView.textEntered = { [weak self] text in
            self?.presenter?.textEntered(fieldType: .name, text: text)
        }
        
        taskView.textEntered = { [weak self] text in
            self?.presenter?.textEntered(fieldType: .task, text: text)
        }
        
        tf.textEntered = { [weak self] text in
            self?.presenter?.textEntered(fieldType: .endDate, text: text)
        }
        
        addBtnButton.touchUp = { [weak self] _ in
            self?.presenter?.onNext()
        }
    }
    
    deinit {
        deregisterForKeyboardNotifications()
        print("AddTaskViewController is deinit")
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
        
        containerViewConstraintBottom?.constant = offset
        if isFullScreen {
            containerViewConstraintTop?.constant = 0
            currentTopConstraint = 0
        } else {
            containerViewConstraintTop?.constant = view.frame.size.height - offset - defaultHeight
            
            currentTopConstraint = view.frame.size.height - offset - defaultHeight
        }
    }
}

// MARK: - AddTaskPresenterOutput

extension AddTaskViewController {
    
    func setButtonEnabled(enabled: Bool) {
        addBtnButton.alpha = enabled ? 1.0 : 0.5
    }
    
    func taskAdded(with task: TaskModel) {
        animateDismissView(with: task)
    }
}

// MARK: - setup Presentation ViewController
private extension AddTaskViewController {
    
    @objc func animateDismissViewWithTap() {
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.dimmedView.alpha = 0
            self?.containerView.alpha = 0
            self?.view.endEditing(true)
            self?.navController?.isNavigationBarHidden = true
        } completion: { [weak self] _ in
            self?.onCompletion?()
        }
    }
    
    func animateDismissView(with task: TaskModel) {
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.dimmedView.alpha = 0
            self?.containerView.alpha = 0
            self?.view.endEditing(true)
            self?.navController?.isNavigationBarHidden = true
        } completion: { [weak self] _ in
            self?.taskAdded?(task)
        }
    }
    
    func setupGestures() {
        let dismissGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(animateDismissViewWithTap))
        dimmedView.addGestureRecognizer(dismissGesture)
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        containerView.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanAction(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        let isDraggingDown = translation.y > 30
        let isDraggingUp = translation.y < -50
        
        let newHeight = currentTopConstraint + translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight > 100 {
                
                containerViewConstraintTop?.constant = newHeight
                
            }
        case .ended:
            
            if isDraggingDown {
                animateDismissViewWithTap()
            } else if isDraggingUp {
                isFullScreen = true
                animateToFullHeight(maximumContainerHeight)
                self.topGreyLineView.isHidden = true
                self.hideKeyboardWhenTappedAround()
                
            } else {
                containerViewConstraintTop?.constant = currentTopConstraint
            }
            
        default:
            break
        }
    }
    
    func animateToFullHeight(_ height: CGFloat) {
        containerView.removeGestureRecognizer(panGesture)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.containerViewConstraintTop?.constant = 0
            self?.dimmedView.backgroundColor = .white
            self?.dimmedView.alpha = 1
            self?.navController?.isNavigationBarHidden = false
            self?.tf.isHidden = false
        }
    }
    
    func animateShowDimmedView() {
        UIView.animate(withDuration: 0.2) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
}
