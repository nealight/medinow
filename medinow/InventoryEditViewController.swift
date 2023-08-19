//
//  InventoryEditViewController.swift
//  medinow
//
//  Created by Yi Xu on 5/22/23.
//

import Foundation
import VisionKit
import Vision
import UIKit

class InventoryEditViewController: UIViewController {
    let drugInfoTextFieldFactory = DrugInfoTextFieldFactory()
    unowned let coordinator: InventoryCoordinator
    let inventoryService: InventoryServiceProvider
    lazy var drugImageView = UIImageView()
    var drugInventoryImage: UIImage?
    let cameraButton = UIButton(type: .system)
    lazy var drugNameTF = drugInfoTextFieldFactory.create(placeholder: NSLocalizedString("Drug Name", comment: ""))
    lazy var capletQuantityTF = drugInfoTextFieldFactory.create(placeholder: NSLocalizedString("Quantity", comment: ""))
    
    
    init(coordinator: InventoryCoordinator, inventoryService: InventoryServiceProvider) {
        self.coordinator = coordinator
        self.inventoryService = inventoryService
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
        setupDrugImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.drugInventoryImage == nil {
            self.drugImageView.isHidden = true
        } else {
            self.drugImageView.image = self.drugInventoryImage
            self.drugImageView.isHidden = false
        }
        self.view.layoutIfNeeded()
        self.cameraButton.isHidden = !self.drugImageView.isHidden
    }
    
    private func saveDrugInventory() {
        guard let drugInventoryImage = drugInventoryImage else {
            let alert = UIAlertController(title: NSLocalizedString("No Image Taken", comment: ""), message: NSLocalizedString("Please add a photo to the drug that you are adding to your inventory.", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: .cancel))
            present(alert, animated: true)
            return
        }
        
        inventoryService.saveDrugInventory(drugInventory: DrugInventoryModel(uuid: UUID(), snapshot: drugInventoryImage.jpegData(compressionQuality: 1), name: drugNameTF.text ?? "N/A", expirationDate: .now + 365, originalQuantity: Int64(capletQuantityTF.text!) ?? 0, remainingQuantity: Int64(capletQuantityTF.text!) ?? 0))
        coordinator.saveInventoryEditTapped()
    }
    
    func setupNavigation() {
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("Inventory Detail", comment: "")
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
    
    func setupDrugImage() {
        drugImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drugImageView)
        NSLayoutConstraint.activate([
            drugImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            drugImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            drugImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
        let cellPerRow: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 4 : 2
        let width = (view.frame.size.width / cellPerRow - 15 - 20 - 60)
        let height = (view.frame.size.width / cellPerRow - 15 - 20 - 20)
        let ratio = width / height
        NSLayoutConstraint.activate([
            drugImageView.heightAnchor.constraint(equalTo: drugImageView.widthAnchor, multiplier: ratio)
        ])
        drugImageView.contentMode = .scaleAspectFill
        drugImageView.clipsToBounds = true
        drugImageView.layer.cornerRadius = 20
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
