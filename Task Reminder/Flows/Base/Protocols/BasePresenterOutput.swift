//
//  BasePresenterOutput.swift
//
//
//

protocol BasePresenterOutput: AnyObject {
    
    func onAnimating(isStart: Bool)
    func showErrorDialog(title: String?, message: String?, onButton: CompletionBlock?)
    func showQuetionDialogQuetion(dialogModel: DialogModel)
    
}

extension BasePresenterOutput {
    
    func showErrorDialog(
        title: String? = nil,
        message: String? = nil,
        onButton: CompletionBlock? = nil) {
            
            showErrorDialog(title: title, message: message, onButton: onButton)
        }
    
    func showQuetionDialogQuetion(dialogModel: DialogModel) {
        showQuetionDialogQuetion(dialogModel: dialogModel)
    }
}

