//
//  FirstViewController.swift
//  medinow
//
//  Created by Yi Xu on 4/21/23.
//

import UIKit

class MedicationListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MedicationListCell
//        cell.backgroundColor = .systemCyan
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
    
    @objc func addTapped() {
        let navVC = UINavigationController(rootViewController: MedicineEditViewController())
        present(navVC, animated: true)
    }
    
    func setupNavigation() {
        self.navigationController?.navigationBar.topItem?.title = "Medications"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        addButton.tintColor = .systemBlue
        self.navigationItem.rightBarButtonItem =
        addButton
    }

    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.register(MedicationListCell.self, forCellReuseIdentifier: "cellId")
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
        
    }
}

