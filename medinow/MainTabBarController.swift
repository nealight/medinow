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
        let perscriptionNavVC = UINavigationController(rootViewController: perscriptionVC)
        let perscriptionTab = UITabBarItem(title: "Perscriptions", image: .init(systemName: "pills.fill"), tag: 0)
        perscriptionNavVC.tabBarItem = perscriptionTab
        self.viewControllers = [perscriptionNavVC, ]
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.title ?? "None")")
    }
    
}
