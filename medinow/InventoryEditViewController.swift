//
//  InventoryEditViewController.swift
//  medinow
//
//  Created by Yi Xu on 5/22/23.
//

import Foundation
import UIKit
import Vision

class InventoryEditViewController: UIViewController {
    let coordinator = (UIApplication.shared.delegate as! AppDelegate).coordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigation()
        setupCameraButton()
    }
    
    func setupNavigation() {
        self.navigationController?.navigationBar.topItem?.title = "Inventory Detail"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction() {
            [self] _ in
            self.coordinator.cancelInventoryEditTapped()
        })
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
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func capturedDrugImage(image: UIImage) {
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
