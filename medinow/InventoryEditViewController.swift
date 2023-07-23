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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let coordinator = (UIApplication.shared.delegate as! AppDelegate).coordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigation()
        setupCameraButton()
    }
    
    func setupNavigation() {
        self.navigationController?.navigationBar.topItem?.title = "Inventory Detail"
    }
    
    func setupCameraButton() {
        let cameraButton = UIButton(type: .system)
        cameraButton.layer.cornerRadius = 20
        cameraButton.backgroundColor = .systemBlue.withAlphaComponent(0.15)
        cameraButton.tintColor = .systemBlue
        cameraButton.setTitle("Capture Drug Description", for: .normal)
        
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraButton)
        NSLayoutConstraint.activate([
            cameraButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cameraButton.heightAnchor.constraint(equalToConstant: 40),
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
//                    print(text.string)
//                    print(text.confidence)
//                    print(observation.boundingBox.size)
//                    print("\n")
                }
            }
        }
        
        recognizedObservations.sort { ob1, ob2 in
            ob1.boundingBox.height * ob1.boundingBox.width > ob2.boundingBox.height * ob2.boundingBox.width
        }
        
        for observation in recognizedObservations.prefix(upTo: 3) {
            print(observation.topCandidates(1).first?.string ?? "")
        }
    }
    
    func capturedDrugImage(image: UIImage) {
        let request = VNRecognizeTextRequest(completionHandler: handleTextRecognition)
        request.minimumTextHeight = 1/16
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en-US"]

        
        let imageRequestHandler = VNImageRequestHandler(cgImage:image.cgImage!, orientation: .right, options: [:])
        DispatchQueue.global().async {
            try? imageRequestHandler.perform([request, ])
        }
    }
}
