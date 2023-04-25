//
//  MedicineEditViewController.swift
//  medinow
//
//  Created by Yi Xu on 4/23/23.
//

import Foundation
import UIKit
import CoreData

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

class MedicineEditViewController: UIViewController, UITextFieldDelegate {
    
    let nameTF = UITextField()
    let frequencyTextLabel = UILabel()
    let frequencyTextField = UITextField()
    let frequencyPicker = UIPickerView()
    let anotherViewController = LoadingViewController()
    let frequencyPickerOptions = [1, 2, 3, 4]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigation()
        setupNameTF()
        setupFrequencyLabel()
        setupFrequencyPicker()
        setupAnotherView()
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if (textField == nameTF) {
            print("nameTF Finished Editing")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setupNavigation() {
        self.navigationController?.navigationBar.topItem?.title = "Medication Detail"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveChanges))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissMyself))
        self.navigationItem.rightBarButtonItem?.tintColor = .systemBlue
        self.navigationItem.leftBarButtonItem?.tintColor = .systemBlue
    }
    
    @objc func dismissMyself() {
        dismiss(animated: true)
    }
    
    @objc func saveChanges() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "DrugPerscription", in: context)
        let newDrug = NSManagedObject(entity: entity!, insertInto: context)
        
        newDrug.setValue(nameTF.text, forKey: "name")
        newDrug.setValue(frequencyPickerOptions[frequencyPicker.selectedRow(inComponent: 0)], forKey: "dailyDosage")
        do {
            try context.save()
        } catch {
            print("Error saving")
        }
        
        
        dismiss(animated: true)
    }
    
    func setupNameTF() {
        nameTF.delegate = self
        nameTF.returnKeyType = .done
        
        
        nameTF.placeholder = "Medication Name"
        nameTF.minimumFontSize = 16
        nameTF.borderStyle = .roundedRect
        nameTF.tintColor = .systemBlue
        nameTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTF)
        NSLayoutConstraint.activate([
            nameTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameTF.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            nameTF.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupFrequencyLabel() {
        frequencyTextLabel.text = "Pills per day"
        frequencyTextLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(frequencyTextLabel)
        NSLayoutConstraint.activate([
            frequencyTextLabel.topAnchor.constraint(equalTo: nameTF.bottomAnchor, constant: 20),
            frequencyTextLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            frequencyTextLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5)
        ])
    }
    
    func setupFrequencyPicker() {
        frequencyTextField.inputView = frequencyPicker
        
        frequencyTextField.borderStyle = .roundedRect
        frequencyTextField.tintColor = .systemBackground
        frequencyTextField.textAlignment = .center
        
        frequencyPicker.translatesAutoresizingMaskIntoConstraints = false
        frequencyTextField.translatesAutoresizingMaskIntoConstraints = false
        
        frequencyPicker.dataSource = self
        frequencyPicker.delegate = self
        
        frequencyPicker.selectRow(0, inComponent: 0, animated: false)
        frequencyTextField.text = "\(frequencyPickerOptions[frequencyPicker.selectedRow(inComponent: 0)])"
        
        view.addSubview(frequencyTextField)
        NSLayoutConstraint.activate([
            frequencyTextField.topAnchor.constraint(equalTo: frequencyTextLabel.topAnchor),
            frequencyTextField.bottomAnchor.constraint(equalTo: frequencyTextLabel.bottomAnchor),
            frequencyTextField.leadingAnchor.constraint(equalTo: frequencyTextLabel.trailingAnchor, constant: 20),
            frequencyTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
        
        addKeyboardToolBar()
    }
    
    func addKeyboardToolBar() {

        var nextButton: UIBarButtonItem
        let keyboardToolBar = UIToolbar(frame: CGRect(x: CGFloat(0), y:
                                                        CGFloat(0), width: CGFloat(frequencyPicker.frame.size.width), height: CGFloat(25)))
        keyboardToolBar.sizeToFit()
        keyboardToolBar.barStyle = .default
        frequencyTextField.inputAccessoryView = keyboardToolBar
        nextButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.frequencyPickerViewSelected))
        nextButton.tintColor = .systemBlue
        keyboardToolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), nextButton]

    }
    
    @objc func frequencyPickerViewSelected() {
        self.frequencyTextField.endEditing(false)
    }
    
    func setupAnotherView() {
        self.addChild(anotherViewController)
        anotherViewController.didMove(toParent: self)
        
        let anotherView = anotherViewController.view!
        anotherView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(anotherView)
        
        NSLayoutConstraint.activate([
            anotherView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            anotherView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            anotherView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            anotherView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
}

extension MedicineEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return frequencyPickerOptions.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(frequencyPickerOptions[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        frequencyTextField.text = "\(frequencyPickerOptions[row])"
    }
}

