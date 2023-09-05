//
//  MainCoordinator.swift
//  medinow
//
//  Created by Yi Xu on 5/9/23.
//

import Foundation
import UIKit

protocol PrescriptionCoordinator: AnyObject {
    func addPrescriptionTapped()
    func savePrescriptionTapped(text: String, dosage: Int64)
    func cancelPrescriptionEditTapped()
    func getPrescriptionDataSource() -> PrescriptionDataSource
    func editPrescription(for name: String)
}

protocol InventoryCoordinator: AnyObject {
    func addInventoryTapped()
    func inverntoryCameraButtonTapped()
    func setInventoryDrugImage(image: UIImage?)
    func cancelInventoryEditTapped()
    func saveInventoryEditTapped()
}


class MainCoordinator: Coordinator {
    lazy var inventoryVC = {
        let inventoryVCLayout = UICollectionViewFlowLayout()
        let cellPerRow: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 4 : 2
        inventoryVCLayout.itemSize = CGSize(width: UIScreen.main.bounds.width / cellPerRow - 15, height: UIScreen.main.bounds.width / cellPerRow - 15)
        inventoryVCLayout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        inventoryVCLayout.minimumLineSpacing = 10
        inventoryVCLayout.minimumInteritemSpacing = 10
        
        let inventoryVC = InventoryListViewController(coordinator: self, inventoryService: self.inventoryService, collectionViewLayout: inventoryVCLayout)
        return inventoryVC
    }()
    
    lazy var prescriptionVC = PrescriptionListViewController(coordinator: self)
    let drugInfoTextFieldFactory = DrugInfoTextFieldFactory()
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    let drugPrescriptionService = DrugPrescriptionService()
    let inventoryService = InventoryService()
    
    lazy var mainTabBarController: MainTabBarController = MainTabBarController(inventoryVC: inventoryVC, prescriptionVC: prescriptionVC)
    lazy var savedPrescriptionEditViewController: PrescriptionDetailViewController? = PrescriptionDetailViewController(coordinator: self, drugPrescriptionService: drugPrescriptionService, textFieldFactory: drugInfoTextFieldFactory)
    lazy var inventoryEditViewController = InventoryEditViewController(coordinator: self, inventoryService: inventoryService, textFieldFactory: drugInfoTextFieldFactory)
    var drugImageCameraController: DrugImageCameraController?
    
    private var _prescriptionLastSaved: Bool
    var prescriptionLastSaved: Bool {
        get {
            return self._prescriptionLastSaved
        }
        set (newValue) {
            _prescriptionLastSaved = newValue
            if (newValue) {
                self.savedPrescriptionEditViewController = nil
            }
        }
    }
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
        _prescriptionLastSaved = true
    }
    
    func start() {
        navigationController.pushViewController(mainTabBarController, animated: false)
    }
}

extension MainCoordinator: PrescriptionCoordinator {
    func editPrescription(for name: String) {
        prescriptionLastSaved = true
        
        drugPrescriptionService.fetchDrug(for: name) { object in
            self.originalPerscriptionName = object.value(forKey: "name") as? String
            
            let prescriptionEditViewController = PrescriptionDetailViewController(coordinator: self, drugPrescriptionService: self.drugPrescriptionService, filledName: object.value(forKey: "name") as? String, filledDailyDosage:  String(object.value(forKey: "dailyDosage") as! Int64), textFieldFactory: self.drugInfoTextFieldFactory)
            
            DispatchQueue.main.async {
                self.navigationController.pushViewController(prescriptionEditViewController, animated: true)
            }
        }
    }
    
    func addPrescriptionTapped() {
        let savedPrescriptionEditViewController = prescriptionLastSaved ? PrescriptionDetailViewController(coordinator: self, drugPrescriptionService: drugPrescriptionService, textFieldFactory: drugInfoTextFieldFactory) : self.savedPrescriptionEditViewController!
        savedPrescriptionEditViewController.isEditing = true
        navigationController.pushViewController(savedPrescriptionEditViewController, animated: true)
        self.savedPrescriptionEditViewController = savedPrescriptionEditViewController
    }
    
    func savePrescriptionTapped(text: String, dosage: Int64) {
        if let originalPerscriptionName = originalPerscriptionName {
            drugPrescriptionService.editPrescription(prescription: .init(name: text, dailyDosage: dosage), originalName: originalPerscriptionName)
            self.originalPerscriptionName = nil
        } else {
            drugPrescriptionService.insertPrescription(prescription: .init(name: text, dailyDosage: Int64(dosage)))
            prescriptionLastSaved = true
        }
        navigationController.popViewController(animated: true)
    }
    
    func cancelPrescriptionEditTapped() {
        if originalPerscriptionName == nil {
            prescriptionLastSaved = false
        }
        navigationController.popViewController(animated: true)
    }
    
    func getPrescriptionDataSource() -> PrescriptionDataSource {
        return PrescriptionDataSource(drugPrescriptionService: drugPrescriptionService)
    }
}

extension MainCoordinator: InventoryCoordinator {
    func addInventoryTapped() {
        inventoryEditViewController.isEditing = true
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
        inventoryEditViewController = InventoryEditViewController(coordinator: self, inventoryService: inventoryService, textFieldFactory: drugInfoTextFieldFactory)
    }
}


