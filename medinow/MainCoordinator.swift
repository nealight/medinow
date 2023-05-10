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
    var perscriptionLastSaved = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
    }
    
    func start() {
        navigationController.pushViewController(mainTabBarController, animated: false)
    }
    
    func addPerscriptionTapped() {
        if perscriptionLastSaved {
            perscriptionEditViewController = PerscriptionEditViewController()
        }
        let navVC = UINavigationController(rootViewController: perscriptionEditViewController)
        navVC.modalPresentationStyle = .fullScreen
        navigationController.present(navVC, animated: true)
    }
    
    func savePerscriptionTapped() {
        perscriptionLastSaved = true
        perscriptionEditViewController.dismiss(animated: true)
    }
    
    func cancelPerscriptionEditTapped() {
        perscriptionLastSaved = false
        perscriptionEditViewController.dismiss(animated: true)
    }
    
}
