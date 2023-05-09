//
//  MainCoordinator.swift
//  medinow
//
//  Created by Yi Xu on 5/9/23.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    lazy var mainTabBarController = MainTabBarController()
    lazy var perscriptionEditViewController = PerscriptionEditViewController()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
    }
    
    func start() {
        navigationController.pushViewController(mainTabBarController, animated: false)
    }
    
    func addPerscriptionTapped() {
        let navVC = UINavigationController(rootViewController: perscriptionEditViewController)
        navVC.modalPresentationStyle = .fullScreen
        navigationController.present(navVC, animated: true)
    }
    
    
}
