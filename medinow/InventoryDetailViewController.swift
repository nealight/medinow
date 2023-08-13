//
//  InventoryDetailViewController.swift
//  Cappie
//
//  Created by Yi Xu on 8/5/23.
//

import UIKit
import CoreData

class InventoryDetailViewController: UIViewController {
    let coordinator: InventoryCoordinator
    let inventoryService: InventoryServiceProvider
    
    init(coordinator: InventoryCoordinator, inventoryService: InventoryServiceProvider) {
        self.coordinator = coordinator
        self.inventoryService = inventoryService
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
