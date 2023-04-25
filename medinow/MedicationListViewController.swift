//
//  FirstViewController.swift
//  medinow
//
//  Created by Yi Xu on 4/21/23.
//

import UIKit
import CoreData

class MedicationListViewController: UIViewController, UITableViewDelegate {
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemBackground
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var drugs: Array<DrugPerscriptionModel> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTableData()
    }
    
    @objc func addTapped() {
        let navVC = UINavigationController(rootViewController: MedicineEditViewController())
        navVC.modalPresentationStyle = .fullScreen
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

extension MedicationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MedicationListCell
        cell.medicationLabel.text = drugs[indexPath.row].name
//        cell.backgroundColor = .systemCyan
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func loadTableData() {
        drugs = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DrugPerscription")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                drugs.append(DrugPerscriptionModel(name: data.value(forKey: "name") as! String, dailyDosage: data.value(forKey: "dailyDosage") as! Int64))
            }
        } catch {
            fatalError("CoreData fatch error")
        }
        
        tableView.reloadData()
    }
}

