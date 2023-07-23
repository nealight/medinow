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
    lazy var inventoryEditViewController = InventoryEditViewController()
    var perscriptionLastSaved = false
    
    var capturedInventoryDrugImage: UIImage?
    
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
    
    func getPerscriptionDataSource() -> PerscriptionDataSource {
        return PerscriptionDataSource()
    }
    
    func addInventoryTapped() {
        let navVC = UINavigationController(rootViewController: inventoryEditViewController)
        navVC.modalPresentationStyle = .fullScreen
        navigationController.present(navVC, animated: true)
    }
    
    func inverntoryCameraButtonTapped() {
        let vc = DrugImageCameraController()
        vc.sourceType = .camera
        vc.allowsEditing = false
        vc.delegate = vc
        inventoryEditViewController.present(vc, animated: true)
    }
    
    func setInventoryDrugImage(image: UIImage?) {
        guard let image = image else {
            print("No image found")
            inventoryEditViewController.dismiss(animated: true)
            return
        }
        capturedInventoryDrugImage = image
        inventoryEditViewController.dismiss(animated: true)
        inventoryEditViewController.capturedDrugImage(image: image)
    }
    
    
}


