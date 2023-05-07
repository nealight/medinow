//
//  FirstViewController.swift
//  medinow
//
//  Created by Yi Xu on 4/21/23.
//

import UIKit
import CoreData

class PerscriptionListViewController: UIViewController, UITableViewDelegate {
    var fetch_offset = 0
    let Rows_Each_Load = 20
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemBackground
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var drugs: Array<DrugPerscriptionModel> = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        let navVC = UINavigationController(rootViewController: PerscriptionEditViewController())
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
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
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.register(PerscriptionListCell.self, forCellReuseIdentifier: "cellId")
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
        
    }
    
}

extension PerscriptionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! PerscriptionListCell
        cell.medicationLabel.text = drugs[indexPath.row].name
        
        let dailyDosage = drugs[indexPath.row].dailyDosage
        cell.dosageLabel.text = "\(dailyDosage) pill\(dailyDosage == 1 ? "" : "s") per day"
        
        if (indexPath.row == drugs.count - 1) {
            loadTableData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func loadTableData() {
        var fetched_drugs: [DrugPerscriptionModel] = []
        let context = appDelegate.persistentContainer.newBackgroundContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DrugPerscription")
        request.returnsObjectsAsFaults = false
        fetch_offset += Rows_Each_Load
        request.fetchLimit = fetch_offset;
        context.perform {
            let result = try! context.fetch(request)
            for data in result as! [NSManagedObject] {
                fetched_drugs.append(DrugPerscriptionModel(name: data.value(forKey: "name") as! String, dailyDosage: data.value(forKey: "dailyDosage") as! Int64))
            }
            if self.drugs != fetched_drugs {
                self.drugs = fetched_drugs
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action: UIContextualAction = .init(style: .normal, title: nil, handler: {[self, indexPath] _,_,completionHandler in
            print("delete detected!")
            let context = self.appDelegate.persistentContainer.newBackgroundContext()
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DrugPerscription")
            request.predicate = NSPredicate(format:"name=%@", drugs[indexPath.row].name)
            context.perform {
                let result = try! context.fetch(request)
                let data = result[0]
                let object = data as! NSManagedObject
                context.delete(object)
                try! context.save()
                
                self.drugs.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    self.tableView.deleteRows(at: [indexPath, ], with: .left)
                    completionHandler(true)
                }
            }
        })
        action.backgroundColor = .systemBackground
        action.image = UIImage(systemName: "delete.backward.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        return UISwipeActionsConfiguration(actions: [action, ])
    }
    
}

