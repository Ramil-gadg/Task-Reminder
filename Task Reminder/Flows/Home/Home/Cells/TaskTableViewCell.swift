//
//  TaskTableViewCell.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 30.03.2022.
//  
//
import UIKit

class TaskTableViewCell: UITableViewCell {
    
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var view: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private var doneBtn: ActionButton = {
        let btn = ActionButton()
        btn.setImage(UIImage(named: "ic_checkbox_on"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var verticalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var name: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var task: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        lbl.textColor = .darkGray
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var remainingTime: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        lbl.textColor = .lightGray
        lbl.isHidden = true
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var timeLineView: UIProgressView = {
        let view = UIProgressView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var timesUp: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        lbl.text = "time_is_up".localized
        lbl.textColor = .red
        lbl.isHidden = true
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var model: TaskCellModel?
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        contentView.isUserInteractionEnabled = true
        initUI()
        initConstraints()
        initListeners()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        timeLineView.tintColor = .lightGray
        timeLineView.progressTintColor = .green
        addSubview(shadowView)
        shadowView.addSubview(view)
        view.addSubviews(stackView, doneBtn, verticalLine)
        stackView.addArrangedSubviews([name, task, timesUp, remainingTime, timeLineView])
        
    }
    
    private func initConstraints() {
        
        let stackViewConstrintBottom = stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        stackViewConstrintBottom.priority = UILayoutPriority(750)
        
        let viewConstrintBottom = view.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -8)
        viewConstrintBottom.priority = UILayoutPriority(750)
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: self.topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            shadowView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            view.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 8),
            view.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -16),
            viewConstrintBottom,
            
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: doneBtn.leadingAnchor, constant: -10),
            stackViewConstrintBottom,
            
            verticalLine.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            verticalLine.leadingAnchor.constraint(equalTo: doneBtn.leadingAnchor),
            verticalLine.widthAnchor.constraint(equalToConstant: 1),
            verticalLine.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            
            doneBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            doneBtn.widthAnchor.constraint(equalToConstant: 40),
            doneBtn.topAnchor.constraint(equalTo: view.topAnchor),
            doneBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func initListeners() {

        doneBtn.touchUp = { [weak self] _ in
            self?.model?.doneBtnTapped()
        }
    }
    
    func configure(with model: TaskCellModel) {
        self.model = model
        name.text = model.name
        task.text = model.task
        
        setupTime()
    }
    
    func update(with model: TaskCellModel ) {
        self.model = model
        setupTime()
    }
    
    func setupTime() {
        
        guard let model = model else { return }
        
        switch model.withTime {
            
        case true:
            switch model.isExpired {
                
            case true:
                timesUp.isHidden = false
                remainingTime.isHidden = true
                timeLineView.isHidden = true
            case false:
                timesUp.isHidden = true
                remainingTime.isHidden = false
                timeLineView.isHidden = false
                remainingTime.text = model.remainingTime
                timeLineView.progress = 1 - model.remainingCoef
            }
            
        case false:
            remainingTime.isHidden = true
            timeLineView.isHidden = true
            timesUp.isHidden = true
        }
    }
}
