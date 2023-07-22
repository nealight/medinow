//
//  InventoryEditViewController.swift
//  medinow
//
//  Created by Yi Xu on 5/22/23.
//

import Foundation
import UIKit

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
        cameraButton.addAction(cameraAction, for: .touchDown)
    }
}
