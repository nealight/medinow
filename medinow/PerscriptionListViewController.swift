//
//  FirstViewController.swift
//  medinow
//
//  Created by Yi Xu on 4/21/23.
//

import UIKit

class PerscriptionListViewController: UIViewController {
    let coordinator = (UIApplication.shared.delegate as! AppDelegate).coordinator
    lazy var dataSource = coordinator.getPerscriptionDataSource()
    
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
        coordinator.addPerscriptionTapped()
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
        
        tableView.register(PerscriptionListCell.self, forCellReuseIdentifier: "PerscriptionListCell")
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
        
    }
    
}

extension PerscriptionListViewController: UITableViewDelegate {
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
}
