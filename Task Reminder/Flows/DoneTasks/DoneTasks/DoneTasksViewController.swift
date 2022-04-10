//
//  DoneTasksViewController.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 10.04.2022.
//  
//

import UIKit

    /**
     DoneTasks экран с выполненными задачами
     */
class DoneTasksViewController: BaseViewController,
                               DoneTasksAssemblable,
                               WithNavigationItem {
    
    var presenter: DoneTasksPresenterInput?
    
    var onCompletion: CompletionBlock?
    
    var tasks = [DoneTaskCellModel]()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.separatorStyle = .none
        tv.estimatedRowHeight = UITableView.automaticDimension
        tv.backgroundColor = .clear
        tv.refreshControl = UIRefreshControl()
        tv.tintColor = .white
        tv.refreshControl?.addTarget(
            self,
            action: #selector(callPullToRefresh),
            for: .valueChanged
        )
        tv.delegate = self
        tv.dataSource = self
        tv.dragInteractionEnabled = true
        tv.register(
            DoneTaskTableViewCell.self,
            forCellReuseIdentifier: DoneTaskCellModel.reuseIdentifier
        )
        tv.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navController?.setNavigationBarHidden(false, animated: true)
        presenter?.onStart(animating: true)

    }
    
    override func initUI() {
        title = "tab_done_tasks".localized

        view.addSubviews(tableView)
        
    }
    
    override func initConstraints() {
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }
    
    override func initListeners() {
        navigationItem(set: .right(type: .clearAll)) { [weak self] _ in
            self?.presenter?.deleteAllTasks()
        }
    }

    deinit {
        print("DoneTasksViewController is deinit")
    }
    
    @objc func callPullToRefresh() {
        presenter?.onStart(animating: false)
    }
}

// MARK: - DoneTasksPresenterOutput

extension DoneTasksViewController {
    
    func prepareData(with tasks: [TaskModel]) {
        
        let taskCellModels = tasks.map {
            DoneTaskCellModel(with: $0, delegate: self)
        }
        self.tasks = taskCellModels
        
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
}

extension DoneTasksViewController: DoneTaskCellModelDelegate {
    func doneBtnTapped(with id: String, name: String) {
        showQuetionDialogQuetion(
            dialogModel: DialogModel(
                title: "alert_t_task_not_done".localized,
                message: "\(name) \("alert_m_task_not_done".localized)",
                yesTitle: "alert_a_yes".localized,
                noTitle: "alert_a_no".localized,
                onYes: { [weak self] in
                    self?.presenter?.onDoneTask(with: id)

                },
                onNo: {}
            )
        )
    }
}
