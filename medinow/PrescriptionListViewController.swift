//
//  FirstViewController.swift
//  medinow
//
//  Created by Yi Xu on 4/21/23.
//

import UIKit
import CoreData

class PrescriptionListViewController: UIViewController {
    unowned let coordinator: PrescriptionCoordinator
    lazy var dataSource = coordinator.getPrescriptionDataSource()
    
    init(coordinator: PrescriptionCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemBackground
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func addTapped() {
        coordinator.addPrescriptionTapped()
    }
    
    @objc func editTapped() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        self.navigationItem.leftBarButtonItem = doneButton
        self.tableView.isEditing = true
    }
    
    @objc func doneTapped() {
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        self.navigationItem.leftBarButtonItem = editButton
        self.tableView.isEditing = false
    }
    
    func setupNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = editButton
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = dataSource
        view.addSubview(tableView)
        
        tableView.register(PrescriptionListCell.self, forCellReuseIdentifier: "PrescriptionListCell")
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
        dataSource.loadTableData(self.tableView)
        
        NotificationCenter.default.addObserver(forName: NSPersistentCloudKitContainer.eventChangedNotification, object: nil, queue: .main) { [weak self] notification in

            guard let event = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey] as? NSPersistentCloudKitContainer.Event else {
                return
            }

            let isFinished = event.endDate != nil
            
            switch (event.type, isFinished) {
            case (.import, true):
                // Finished downloading records
                guard let tableView = self?.tableView else {
                    break
                }
                self?.dataSource.loadTableData(tableView)
            default:
                break
            }
        }
    }
    
}

extension PrescriptionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action: UIContextualAction = .init(style: .normal, title: nil, handler: {[self, indexPath] _,_,completionHandler in
            dataSource.deleteRowAt(tableView, indexPath: indexPath, completionHandler: completionHandler)
            
        })
        action.backgroundColor = .systemBackground
        action.image = UIImage(systemName: "delete.backward.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        return UISwipeActionsConfiguration(actions: [action, ])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let drugPerscriptionModel = (tableView.dataSource as! PrescriptionDataSource).getDrug(at: indexPath)
        coordinator.editPrescription(for: drugPerscriptionModel.name)
    }
}
