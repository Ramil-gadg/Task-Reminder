//
//  BaseViewController.swift
//
//
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private var tapInsteadViews: [UIView]?
    
    var navController: BaseNavigationController? {
        self.navigationController as? BaseNavigationController
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        initConstraints()
        initListeners()
        
    }
    
    func initUI() {
    }
    
    func initConstraints() {
    }
    
    func initListeners() {
        
    }
    
    func startAnimating() {
        DispatchQueue.main.async {
            (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.startAnimating()
            
        }
    }
    
    func stopAnimating() {
        DispatchQueue.main.async {
            (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.stopAnimating()
        }
    }
    
    func showErrorDialog(
        title: String? = nil,
        message: String? = nil,
        onButton: CompletionBlock? = nil
    ) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "ok".localized,
                                      style: .default) { _ in
            onButton?()
        })
        present(alert, animated: true)
        
    }
    
    func showQuetionDialogQuetion(dialogModel: DialogModel) {
        
        let alert = UIAlertController(title: dialogModel.title,
                                      message: dialogModel.message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "alert_a_yes".localized,
                                      style: .default) { _ in
            dialogModel.onYes?()
        })
        
        alert.addAction(UIAlertAction(title: "alert_a_no".localized,
                                      style: .default) { _ in
            dialogModel.onNo?()
        })
        present(alert, animated: true)
        
    }
    
    // Gestures
    
    func closeKeyboardByTapAnyware(insteadOf views: [UIView]) {
        tapInsteadViews = views
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(tapAnywhere))
        gestureRecognizer.delegate = self
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func tapAnywhere() {
        view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        guard let tapInsteadViews = tapInsteadViews else {
            return true
        }
        
        for view in tapInsteadViews {
            if let touchView = touch.view, touchView.isKind(of: type(of: view)) {
                return false
            }
        }
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension BaseViewController {
    
    func onAnimating(isStart: Bool) {
        
        isStart ? startAnimating() : stopAnimating()
    }
    
}
