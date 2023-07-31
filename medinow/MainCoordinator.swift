//
//  MainCoordinator.swift
//  medinow
//
//  Created by Yi Xu on 5/9/23.
//

import Foundation
import UIKit

protocol InventoryEditViewControllerCoordinator {
    func addInventoryTapped()
    func inverntoryCameraButtonTapped()
    func setInventoryDrugImage(image: UIImage?)
    func cancelInventoryEditTapped()
    func saveInventoryEditTapped()
}

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let drugPrescriptionService = DrugPrescriptionService()
    lazy var mainTabBarController = MainTabBarController()
    lazy var prescriptionEditViewController = PrescriptionEditViewController(drugPrescriptionService: drugPrescriptionService)
    lazy var inventoryEditViewController = InventoryEditViewController(coordinator: self)
    lazy var drugImageCameraController = DrugImageCameraController()
    var prescriptionLastSaved = false
    
    var capturedInventoryDrugImage: UIImage?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
    }
    
    func start() {
        navigationController.pushViewController(mainTabBarController, animated: false)
    }
    
    func addPrescriptionTapped() {
        if prescriptionLastSaved {
            prescriptionEditViewController = PrescriptionEditViewController(drugPrescriptionService: drugPrescriptionService)
        }
        let navVC = UINavigationController(rootViewController: prescriptionEditViewController)
        navVC.modalPresentationStyle = .fullScreen
        navigationController.present(navVC, animated: true)
    }
    
    func savePrescriptionTapped() {
        prescriptionLastSaved = true
        prescriptionEditViewController.dismiss(animated: true)
    }
    
    func cancelPrescriptionEditTapped() {
        prescriptionLastSaved = false
        prescriptionEditViewController.dismiss(animated: true)
    }
    
    func getPrescriptionDataSource() -> PrescriptionDataSource {
        return PrescriptionDataSource(drugPrescriptionService: drugPrescriptionService)
    }
}

extension MainCoordinator: InventoryEditViewControllerCoordinator {
    func addInventoryTapped() {
        let navVC = UINavigationController(rootViewController: inventoryEditViewController)
        navVC.modalPresentationStyle = .fullScreen
        navigationController.present(navVC, animated: true)
    }
    
    func inverntoryCameraButtonTapped() {
        drugImageCameraController.sourceType = .camera
        drugImageCameraController.allowsEditing = true
        drugImageCameraController.delegate = drugImageCameraController
        inventoryEditViewController.present(drugImageCameraController, animated: true)
    }
    
    func setInventoryDrugImage(image: UIImage?) {
        guard let image = image else {
            NSLog("No image found")
            inventoryEditViewController.dismiss(animated: true)
            return
        }
        capturedInventoryDrugImage = image
        drugImageCameraController.dismiss(animated: true)
        inventoryEditViewController.capturedDrugImage(image: image)
    }
    
    func cancelInventoryEditTapped() {
        inventoryEditViewController.dismiss(animated: true)
    }
    
    func saveInventoryEditTapped() {
        inventoryEditViewController.dismiss(animated: true)
    }
}


