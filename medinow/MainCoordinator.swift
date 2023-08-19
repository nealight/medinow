//
//  MainCoordinator.swift
//  medinow
//
//  Created by Yi Xu on 5/9/23.
//

import Foundation
import UIKit

protocol InventoryCoordinator: AnyObject {
    func addInventoryTapped()
    func inverntoryCameraButtonTapped()
    func setInventoryDrugImage(image: UIImage?)
    func cancelInventoryEditTapped()
    func saveInventoryEditTapped()
}

protocol PrescriptionCoordinator: AnyObject {
    func addPrescriptionTapped()
    func savePrescriptionTapped(text: String, dosage: Int64)
    func cancelPrescriptionEditTapped()
    func getPrescriptionDataSource() -> PrescriptionDataSource
    func editPrescription(for name: String)
}

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    let drugPrescriptionService = DrugPrescriptionService()
    let inventoryService = InventoryService()
    
    lazy var mainTabBarController: MainTabBarController = MainTabBarController(coordinator: self)
    lazy var prescriptionEditViewController = PrescriptionEditViewController(coordinator: self, drugPrescriptionService: drugPrescriptionService)
    lazy var inventoryEditViewController = InventoryEditViewController(coordinator: self, inventoryService: inventoryService)
    var drugImageCameraController: DrugImageCameraController?
    var prescriptionLastSaved = true
    var originalPerscriptionName: String? = nil
    
    var capturedInventoryDrugImage: UIImage?
    
    lazy var inventoryListViewController = {
        let inventoryVCLayout = UICollectionViewFlowLayout()
        let cellPerRow: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 4 : 2
        inventoryVCLayout.itemSize = CGSize(width: UIScreen.main.bounds.width / cellPerRow - 15, height: UIScreen.main.bounds.width / cellPerRow - 15)
        inventoryVCLayout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        inventoryVCLayout.minimumLineSpacing = 10
        inventoryVCLayout.minimumInteritemSpacing = 10
        
        let inventoryVC = InventoryListViewController(coordinator: self, inventoryService: self.inventoryService, collectionViewLayout: inventoryVCLayout)
        return inventoryVC
    }()
    
    lazy var prescriptionListViewController = PrescriptionListViewController(coordinator: self)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
    }
    
    func start() {
        navigationController.pushViewController(mainTabBarController, animated: false)
    }
}

extension MainCoordinator: PrescriptionCoordinator {
    func editPrescription(for name: String) {
        prescriptionEditViewController = PrescriptionEditViewController(coordinator: self, drugPrescriptionService: drugPrescriptionService)
        drugPrescriptionService.fetchDrug(for: name) { object in
            self.originalPerscriptionName = object.value(forKey: "name") as? String
            self.prescriptionEditViewController.nameTF.text = object.value(forKey: "name") as? String
            self.prescriptionEditViewController.frequencyTextField.text = String(object.value(forKey: "dailyDosage") as! Int64)
            
            DispatchQueue.main.async {
                let navVC = UINavigationController(rootViewController: self.prescriptionEditViewController)
                navVC.modalPresentationStyle = .fullScreen
                self.navigationController.present(navVC, animated: true)
            }
        }
    }
    
    func addPrescriptionTapped() {
        if prescriptionLastSaved {
            prescriptionEditViewController = PrescriptionEditViewController(coordinator: self, drugPrescriptionService: drugPrescriptionService)
        }
        let navVC = UINavigationController(rootViewController: prescriptionEditViewController)
        navVC.modalPresentationStyle = .fullScreen
        navigationController.present(navVC, animated: true)
    }
    
    func savePrescriptionTapped(text: String, dosage: Int64) {
        if let originalPerscriptionName = originalPerscriptionName {
            drugPrescriptionService.editPrescription(prescription: .init(name: text, dailyDosage: dosage), originalName: originalPerscriptionName)
            self.originalPerscriptionName = nil
        } else {
            drugPrescriptionService.insertPrescription(prescription: .init(name: text, dailyDosage: Int64(dosage)))
            prescriptionLastSaved = true
        }
        prescriptionEditViewController.dismiss(animated: true)
    }
    
    func cancelPrescriptionEditTapped() {
        if originalPerscriptionName == nil {
            prescriptionLastSaved = false
        }
        prescriptionEditViewController.dismiss(animated: true)
    }
    
    func getPrescriptionDataSource() -> PrescriptionDataSource {
        return PrescriptionDataSource(drugPrescriptionService: drugPrescriptionService)
    }
}

extension MainCoordinator: InventoryCoordinator {
    func addInventoryTapped() {
        let navVC = UINavigationController(rootViewController: inventoryEditViewController)
        navVC.modalPresentationStyle = .fullScreen
        navigationController.present(navVC, animated: true)
    }
    
    func inverntoryCameraButtonTapped() {
        let drugImageCameraController = DrugImageCameraController()
        drugImageCameraController.coordinator = self
        drugImageCameraController.sourceType = .camera
        drugImageCameraController.allowsEditing = true
        drugImageCameraController.delegate = drugImageCameraController
        drugImageCameraController.modalPresentationStyle = .fullScreen
        self.drugImageCameraController = drugImageCameraController
        inventoryEditViewController.present(self.drugImageCameraController!, animated: true)
    }
    
    func setInventoryDrugImage(image: UIImage?) {
        guard let image = image else {
            NSLog("No image found")
            return
        }
        
        capturedInventoryDrugImage = image
        drugImageCameraController!.dismiss(animated: true)
        drugImageCameraController = nil
        inventoryEditViewController.capturedDrugImage(image: image)
    }
    
    func cancelInventoryEditTapped() {
        inventoryEditViewController.navigationController?.dismiss(animated: true)
    }
    
    func saveInventoryEditTapped() {
        inventoryEditViewController.navigationController?.dismiss(animated: true)
        inventoryEditViewController = InventoryEditViewController(coordinator: self, inventoryService: inventoryService)
    }
}


