//
//  MainTabBarController.swift
//  medinow
//
//  Created by Yi Xu on 4/27/23.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBar.backgroundColor = .secondarySystemBackground
        let perscriptionVC = PerscriptionListViewController();
        perscriptionVC.title = "Perscriptions"
        let perscriptionNavVC = UINavigationController(rootViewController: perscriptionVC)
        let perscriptionTab = UITabBarItem(title: perscriptionVC.title, image: .init(systemName: "list.bullet.clipboard.fill"), tag: 0)
        perscriptionNavVC.tabBarItem = perscriptionTab
        
        let inventoryVCLayout = UICollectionViewLayout()
        let inventoryVC = InventoryListViewController(collectionViewLayout: inventoryVCLayout)
        inventoryVC.title = "Inventory"
        let inventoryNavVC = UINavigationController(rootViewController: inventoryVC)
        let inventoryTab = UITabBarItem(title: inventoryVC.title, image: .init(systemName: "cross.case.fill"), tag: 1)
        inventoryNavVC.tabBarItem = inventoryTab
        self.viewControllers = [perscriptionNavVC, inventoryNavVC]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.title ?? "None")")
    }
    
}
