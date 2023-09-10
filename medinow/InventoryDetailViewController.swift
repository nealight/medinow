//
//  InventoryDetailViewController.swift
//  Cappie
//
//  Created by Yi Xu on 8/5/23.
//

import UIKit
import CoreData

class InventoryDetailViewController: UIViewController {
    unowned let coordinator: InventoryCoordinator
    let inventoryService: InventoryServiceProvider
    let componentFactory: InfoComponentFactory = DrugInfoComponentFactory()
    let inputTextFieldFactory: InputTextFieldFactory = DrugInfoTextFieldFactory()
    
    let drug: DrugInventoryModel
    
    init(coordinator: InventoryCoordinator, inventoryService: InventoryServiceProvider, drug: DrugInventoryModel) {
        self.coordinator = coordinator
        self.inventoryService = inventoryService
        self.drug = drug
        super.init(nibName: nil, bundle: nil)
    }

    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupDrugComponents()
        setupDeleteButton()
    }
    
    private func setupNavigation() {
        navigationItem.title = drug.name
    }
    
    private func setupDrugComponents() {
        let leftView = UILabel()
        leftView.text = NSLocalizedString("Quantity", comment: "")
        leftView.textColor = .systemOrange
        leftView.font = .boldSystemFont(ofSize: 20)
        leftView.translatesAutoresizingMaskIntoConstraints = false
        
        let rightView = inputTextFieldFactory.create(placeholder: String(drug.remainingQuantity), isEditing: false)
        rightView.textAlignment = .center
        rightView.delegate = self
        rightView.translatesAutoresizingMaskIntoConstraints = false
        
        let remainingQuantityComponent = componentFactory.create(leftView: leftView, rightView: rightView, isEditing: false)
        view.addSubview(remainingQuantityComponent)
        NSLayoutConstraint.activate([
            remainingQuantityComponent.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            remainingQuantityComponent.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            remainingQuantityComponent.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            remainingQuantityComponent.heightAnchor.constraint(equalToConstant: 40)
        ])
        remainingQuantityComponent.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupDeleteButton() {
        let deleteButton = UIButton(type: .system, primaryAction: UIAction() { _ in
            self.coordinator.deleteInventoryTapped()
            self.inventoryService.removeDrugInventory(uuid: self.drug.uuid) { _ in 
                self.navigationController?.popViewController(animated: true)
            }
        })
        deleteButton.layer.cornerRadius = 20
        deleteButton.backgroundColor = .tintColor.withAlphaComponent(0.15)
        deleteButton.setTitle(NSLocalizedString("Delete", comment: ""), for: .normal)
        deleteButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            deleteButton.heightAnchor.constraint(equalToConstant: 60),
            deleteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            deleteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    
}

extension InventoryDetailViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
