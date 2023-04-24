//
//  MedicineEditViewController.swift
//  medinow
//
//  Created by Yi Xu on 4/23/23.
//

import Foundation
import UIKit

class LoadingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        // Center our spinner both horizontally & vertically
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

class MedicineEditViewController: UIViewController {
    
    let nameTF = UITextField()
    let anotherViewController = LoadingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupNameTF()
        setupAnotherView()
    }
    

    func setupNavigation() {
        self.navigationController?.navigationBar.topItem?.title = "Medication Detail"
    }
    
    func setupNameTF() {
        view.backgroundColor = .systemBackground
        nameTF.placeholder = "Medication Name"
        nameTF.minimumFontSize = 16
        nameTF.borderStyle = .roundedRect
        nameTF.tintColor = .systemBlue
        nameTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTF)
        NSLayoutConstraint.activate([
            nameTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nameTF.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            nameTF.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupAnotherView() {
        self.addChild(anotherViewController)
        
        let anotherView = anotherViewController.view!
        anotherView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(anotherView)
        anotherViewController.didMove(toParent: self)
        NSLayoutConstraint.activate([
            anotherView.topAnchor.constraint(equalTo: nameTF.bottomAnchor, constant: 20),
            anotherView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            anotherView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            anotherView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
}
