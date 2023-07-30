//
//  InventoryEditViewController.swift
//  medinow
//
//  Created by Yi Xu on 5/22/23.
//

import Foundation
import UIKit
import Vision
import CoreData

class InventoryEditViewController: UIViewController {
    let drugInfoTextFieldFactory = DrugInfoTextFieldFactory()
    let coordinator: InventoryEditViewControllerCoordinator
    var drugInventoryImage: UIImage?
    lazy var drugNameTF = drugInfoTextFieldFactory.create(placeholder: "Drug Name")
    lazy var capletQuantityTF = drugInfoTextFieldFactory.create(placeholder: "Quantity")
    
    
    init(coordinator: InventoryEditViewControllerCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupCameraButton()
        setupDrugNameTF()
        setupCapletQuantityTF()
    }
    
    private func saveDrugInventory() {
        let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
        let entity = NSEntityDescription.entity(forEntityName: "DrugInventory", in: context)
        let newDrug = NSManagedObject(entity: entity!, insertInto: context)
        
        newDrug.setValue(drugNameTF.text, forKey: "name")
        newDrug.setValue(Int(capletQuantityTF.text!) ?? 0, forKey: "remainingQuantity")
        newDrug.setValue(Int(capletQuantityTF.text!) ?? 0, forKey: "originalQuantity")
        newDrug.setValue(drugInventoryImage?.jpegData(compressionQuality: 1), forKey: "snapshot")
        context.perform {
            try! context.save()
            DispatchQueue.main.async {
                self.coordinator.cancelInventoryEditTapped()
            }
        }
    }
    
    func setupNavigation() {
        self.navigationController?.navigationBar.topItem?.title = "Inventory Detail"
        let cancelInventoryEditTappedAction = UIAction() { [self] _ in
            coordinator.cancelInventoryEditTapped()
        }
        let saveInventoryEditTappedAction = UIAction() { [self] _ in
            saveDrugInventory()
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: cancelInventoryEditTappedAction)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .save, primaryAction: saveInventoryEditTappedAction)
    }
    
    func setupDrugNameTF() {
        drugNameTF.delegate = self
        view.addSubview(drugNameTF)
        NSLayoutConstraint.activate([
            drugNameTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            drugNameTF.heightAnchor.constraint(equalToConstant: 40),
            drugNameTF.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            drugNameTF.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupCapletQuantityTF() {
        capletQuantityTF.delegate = self
        capletQuantityTF.keyboardType = .numberPad
        view.addSubview(capletQuantityTF)
        NSLayoutConstraint.activate([
            capletQuantityTF.topAnchor.constraint(equalTo: drugNameTF.bottomAnchor, constant: 20),
            capletQuantityTF.heightAnchor.constraint(equalToConstant: 40),
            capletQuantityTF.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            capletQuantityTF.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupCameraButton() {
        let cameraButton = UIButton(type: .system)
        cameraButton.layer.cornerRadius = 20
        cameraButton.backgroundColor = .systemBlue.withAlphaComponent(0.15)
        cameraButton.tintColor = .systemBlue
        cameraButton.setImage(.init(systemName: "camera.fill"), for: .normal)
        cameraButton.titleLabel?.font = .systemFont(ofSize: 16)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraButton)
        NSLayoutConstraint.activate([
            cameraButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            cameraButton.heightAnchor.constraint(equalToConstant: 80),
            cameraButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            cameraButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
        let cameraAction = UIAction() { _ in
            self.coordinator.inverntoryCameraButtonTapped()
        }
        cameraButton.addAction(cameraAction, for: .touchUpInside)
    }
    
    private func handleTextRecognition(request: VNRequest?, error: Error?) {
        if let error = error {
            print("ERROR: \(error)")
            return
        }
        guard let results = request?.results, results.count > 0 else {
            print("No text found")
            return
        }
        var recognizedObservations = [VNRecognizedTextObservation]()
        for result in results {
            if let observation = result as? VNRecognizedTextObservation {
                if (observation.topCandidates(1).first != nil) {
                    recognizedObservations.append(observation)
                }
            }
        }
        recognizedObservations.sort { ob1, ob2 in
            ob1.boundingBox.height * ob1.boundingBox.width > ob2.boundingBox.height * ob2.boundingBox.width
        }
        
        let candidates = recognizedObservations.prefix(3).map{
            return $0.topCandidates(1).first?.string ?? ""
        }
        
        DispatchQueue.main.async {
            self.promptForChoosingDrugName(candidates: candidates)
        }
        
    }
    
    private func promptForChoosingDrugName(candidates: [String]) {
        let alert = UIAlertController(title: "Select the Drug Name", message: "We captured multiple drug names and would like to know which is the right one.", preferredStyle: .alert)
        for candidate in candidates {
            alert.addAction(UIAlertAction(title: NSLocalizedString(candidate, comment: "Default action"), style: .default, handler: { _ in
                NSLog("\"\(candidate)\" has been selected.")
                self.drugNameTF.text = candidate
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func capturedDrugImage(image: UIImage) {
        self.drugInventoryImage = image
        let request = VNRecognizeTextRequest(completionHandler: handleTextRecognition)
        request.minimumTextHeight = 1/16
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["zh-Hans", "en-US"]
        let imageRequestHandler = VNImageRequestHandler(cgImage:image.cgImage!, orientation: .right, options: [:])
        DispatchQueue.global().async {
            try? imageRequestHandler.perform([request, ])
        }
    }
}

extension InventoryEditViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        switch textField {
        case drugNameTF:
            NSLog("Finished Editing drug name")
        case capletQuantityTF:
            NSLog("Finished Editing drug quantity")
        default:
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
