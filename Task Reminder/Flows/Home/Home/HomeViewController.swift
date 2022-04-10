//
//  HomeViewController.swift
//  Task Reminder
//
//  Created by Рамил Гаджиев on 26.03.2022.
//  
//

import UIKit

/**
 Home главный экран с активными задачами
 */
class HomeViewController: BaseViewController,
                          HomeAssemblable,
                          WithNavigationItem {
    
    var presenter: HomePresenterInput?
    
    var onCompletion: CompletionBlock?
    var onAddTask: CompletionBlock?
    var onEditTask: ((TaskModel) -> Void)?
    
    var timer: Timer?
    var commonTasks = [TaskCellModel]()
    var tasks = [TaskCellModel]()
    
    private lazy var segmentControl: UISegmentedControl = {
        let items = ["l_with_time".localized, "l_without_time".localized]
        let segment = UISegmentedControl(items: items)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentTapped), for: .valueChanged)
        return segment
    }()
    
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
            TaskTableViewCell.self,
            forCellReuseIdentifier: TaskCellModel.reuseIdentifier
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    override func initUI() {
        title = "tab_main".localized
        
        view.addSubviews(segmentControl, tableView)
        
    }
    
    override func initConstraints() {
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentControl.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }
    
    override func initListeners() {
        navigationItem(set: .right(type: .logout)) { [weak self] _ in
            self?.stopTimer()
            SessionManager.didSetPin = false
            SessionManager.token = nil
            self?.onCompletion?()
        }
        
        navigationItem(set: .left(type: .add)) { [weak self] _ in
            self?.stopTimer()
            self?.onAddTask?()
        }
    }
    
    func startTimer() {
        
        if timer == nil {
            timer = Timer(timeInterval: 1.0,
                          target: self,
                          selector: #selector(refresh),
                          userInfo: nil,
                          repeats: true)
            RunLoop.current.add(timer!, forMode: .common)
            timer!.tolerance = 0.1
        }
    }
    
    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    deinit {
        print("HomeViewController is deinit")
    }
    
}

// MARK: - private methods

private extension HomeViewController {
    
    @objc private func refresh() {
        print(1)
        if tasks.count > 0 {
            guard let visibleRowsIndexPaths = tableView.indexPathsForVisibleRows else {
                return
            }
            for indexPath in visibleRowsIndexPaths {
                tasks[indexPath.row].update()
            }
        }
    }
    
    @objc func segmentTapped(segment: UISegmentedControl) {
        filterTasks(with: segment.selectedSegmentIndex)
    }
    
    @objc func callPullToRefresh() {
        presenter?.onStart(animating: false)
    }
    
    func filterTasks(with segmentIndex: Int) {
        switch segmentIndex {
        case 0:
            self.tasks = commonTasks
                .filter { $0.withTime == true}
                .sorted(by: { $0.endTime! < $1.endTime! })
        case 1:
            self.tasks = commonTasks.filter { $0.withTime == false}
        default: break
        }
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
}

// MARK: - HomePresenterOutput

extension HomeViewController {
    
    func prepareData(with tasks: [TaskModel]) {
        
        let taskCellModels = tasks.map {
            TaskCellModel(with: $0, delegate: self)
        }
        commonTasks = taskCellModels
        filterTasks(with: segmentControl.selectedSegmentIndex)
        startTimer()
    }
    
}

// MARK: - TaskCellModelDelegate

extension HomeViewController: TaskCellModelDelegate {
    func doneBtnTapped(with id: String, name: String) {
        showQuetionDialogQuetion(
            dialogModel: DialogModel(
                title: "alert_t_task_done".localized,
                message: "\(name) \("alert_m_task_done".localized)",
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

// MARK: - AddTaskProtocol

extension HomeViewController {
    
    func taskAdded(with task: TaskModel) {
        presenter?.onStart(animating: true)
        
    }
}

// MARK: - EditTaskProtocol

extension HomeViewController {
    
    func taskEdit() {
        presenter?.onStart(animating: true)
    }
}
