//
//  MainTabBarController.swift
//  medinow
//
//  Created by Yi Xu on 4/27/23.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    unowned let coordinator: MainCoordinator
    lazy var inventoryVC = {
        let inventoryVCLayout = UICollectionViewFlowLayout()
        let cellPerRow: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 4 : 2
        inventoryVCLayout.itemSize = CGSize(width: UIScreen.main.bounds.width / cellPerRow - 15, height: UIScreen.main.bounds.width / cellPerRow - 15)
        inventoryVCLayout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        inventoryVCLayout.minimumLineSpacing = 10
        inventoryVCLayout.minimumInteritemSpacing = 10
        
        let inventoryVC = InventoryListViewController(coordinator: coordinator, inventoryService: coordinator.inventoryService, collectionViewLayout: inventoryVCLayout)
        return inventoryVC
    }()
    
    lazy var prescriptionVC = PrescriptionListViewController(coordinator: coordinator)
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.backgroundColor = .secondarySystemBackground
        prescriptionVC.title = NSLocalizedString("Prescriptions", comment: "")
        let prescriptionNavVC = UINavigationController(rootViewController: prescriptionVC)
        let prescriptionTab = UITabBarItem(title: prescriptionVC.title, image: .init(systemName: "list.bullet.clipboard.fill"), tag: 0)
        prescriptionNavVC.tabBarItem = prescriptionTab
        
        
        inventoryVC.title = NSLocalizedString("Inventory", comment: "")
        let inventoryNavVC = UINavigationController(rootViewController: inventoryVC)
        let inventoryTab = UITabBarItem(title: inventoryVC.title, image: .init(systemName: "cross.case.fill"), tag: 1)
        inventoryNavVC.tabBarItem = inventoryTab
        self.viewControllers = [prescriptionNavVC, inventoryNavVC]

    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        NSLog("Selected \(viewController.title!)")
    }
    
}
