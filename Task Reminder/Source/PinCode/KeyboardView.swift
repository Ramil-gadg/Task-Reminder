//
//  InfoScreenViewController.swift
//
//
//

import UIKit
import PinLayout

enum ActionKeyboard {
    case delete
    case biometry
    case exit
    
    var number: Int {
        switch self {
        case .delete:
            return -1
        case .exit:
            return -2
        case .biometry:
            return -3
        }
    }
}

final class KeyboardView: BaseView {
    
    var onButton: ((_ number: Int) -> Void)?
    
    private var keysCollectionView = [DigitKeyView]()
    
    private let deleteView: DigitKeyView
    private let exitView: DigitKeyView
    
    let themeDigit: ThemeDigitKeyView
    
    init(with theme: ThemeDigitKeyView = .whiteBG, isExit: Bool) {
        
        self.themeDigit = theme
        self.deleteView = DigitKeyView(number: ActionKeyboard.delete.number, with: theme, isExit: isExit)
        self.exitView = DigitKeyView(number: ActionKeyboard.exit.number, with: theme, isExit: isExit)
        
        for num in 0...9 {
            keysCollectionView.append(
                DigitKeyView(number: num, with: theme, isExit: isExit)
            )
        }
    
        super.init(frame: CGRect.zero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    override func initUI() {

        keysCollectionView.forEach { addSubview($0) }
        addSubviews(deleteView, exitView)
    }
    
    override func initConstraints() { 
    }
    
    private func layout() {
        let digits = keysCollectionView
        
        digits.forEach { $0.pin.width(25%).height(25%) }
        let margin = 12.5%
        
        deleteView.pin.width(25%).height(25%)
        exitView.pin.width(25%).height(25%)
        
        digits[1].pin.left().marginLeft(margin)
        digits[2].pin.left(to: digits[1].edge.right)
        digits[3].pin.left(to: digits[2].edge.right)
        
        digits[4].pin.left().top(to: digits[1].edge.bottom).marginLeft(margin)
        digits[5].pin.top(to: digits[2].edge.bottom).left(to: digits[4].edge.right)
        digits[6].pin.top(to: digits[3].edge.bottom).left(to: digits[5].edge.right)
        
        digits[7].pin.left().top(to: digits[4].edge.bottom).marginLeft(margin)
        digits[8].pin.top(to: digits[5].edge.bottom).left(to: digits[7].edge.right)
        digits[9].pin.top(to: digits[6].edge.bottom).left(to: digits[8].edge.right)
        
        exitView.pin.bottomLeft().marginLeft(margin)
        digits[0].pin.bottomCenter()
        deleteView.pin.bottomRight().marginRight(margin)
    }
    
    override func initListeners() {
        keysCollectionView.forEach { view in
            view.onButton = { number in
                self.onButton?(number)
            }
        }
        
        [deleteView, exitView].forEach { view in
            view.onButton = { number in
                self.onButton?(number)
            }
        }
    }
    
    /**
     Поменять  действие и внешний вид кноки удалить/биометрия
     */
    func changeTypeButton(on btn: ActionKeyboard) {
        switch btn {
        case .biometry:
            deleteView.changeBtnOnBiometry()
        default:
            deleteView.changeBtnOnDelete()
        }
    }
}
