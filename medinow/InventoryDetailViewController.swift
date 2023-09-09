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
    
    let name: String
    let quantity: String
    
    init(coordinator: InventoryCoordinator, inventoryService: InventoryServiceProvider, name: String, quantity: String) {
        self.coordinator = coordinator
        self.inventoryService = inventoryService
        self.name = name
        self.quantity = quantity
        super.init(nibName: nil, bundle: nil)
    }

    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupDrugComponents()
    }
    
    private func setupDrugComponents() {
        let leftView = UILabel()
        leftView.text = name
        leftView.textColor = .systemOrange
        leftView.font = .boldSystemFont(ofSize: 20)
        leftView.translatesAutoresizingMaskIntoConstraints = false
        
        let rightView = inputTextFieldFactory.create(placeholder: quantity, isEditing: false)
        rightView.textAlignment = .center
        rightView.delegate = self
        rightView.translatesAutoresizingMaskIntoConstraints = false
        
        let remainingQuantityComponent = componentFactory.create(leftView: leftView, rightView: rightView, isEditing: false)
        view.addSubview(remainingQuantityComponent)
        NSLayoutConstraint.activate([
            remainingQuantityComponent.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            remainingQuantityComponent.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            remainingQuantityComponent.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            remainingQuantityComponent.heightAnchor.constraint(equalToConstant: 40)
        ])
        remainingQuantityComponent.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
}

extension InventoryDetailViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
