//
//  MedicineEditViewController.swift
//  medinow
//
//  Created by Yi Xu on 4/23/23.
//

import Foundation
import UIKit
import CoreData

class PerscriptionEditViewController: UIViewController, UITextFieldDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let nameTF = UITextField()
    let frequencyTextLabel = UILabel()
    let frequencyTextField = UITextField()
    let frequencyPicker = UIPickerView()
    let frequencyPickerOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigation()
        setupNameTF()
        setupFrequencyLabel()
        setupFrequencyPicker()
        //        setupAnotherView()
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
        self.navigationController?.navigationBar.topItem?.title = "Perscription Detail"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .save, primaryAction: UIAction() { [self] _ in
            let context = appDelegate.persistentContainer.newBackgroundContext()
            let entity = NSEntityDescription.entity(forEntityName: "DrugPerscription", in: context)
            let newDrug = NSManagedObject(entity: entity!, insertInto: context)
            
            newDrug.setValue(nameTF.text, forKey: "name")
            newDrug.setValue(frequencyPickerOptions[frequencyPicker.selectedRow(inComponent: 0)], forKey: "dailyDosage")
            context.perform {
                try! context.save()
                DispatchQueue.main.async {
                    self.appDelegate.coordinator?.savePerscriptionTapped()
                }
            }
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction() {
            [self] _ in
            self.appDelegate.coordinator?.cancelPerscriptionEditTapped()
        })
    }
    
    
    func setupNameTF() {
        nameTF.delegate = self
        nameTF.returnKeyType = .done
        
        nameTF.placeholder = "Drug Name"
        nameTF.minimumFontSize = 20
        nameTF.borderStyle = .roundedRect
        nameTF.backgroundColor = .systemGray6

        nameTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTF)
        NSLayoutConstraint.activate([
            nameTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameTF.heightAnchor.constraint(equalToConstant: 40),
            nameTF.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            nameTF.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupFrequencyLabel() {
        frequencyTextLabel.text = "Pills per day"
        frequencyTextLabel.font.withSize(20)
        frequencyTextLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(frequencyTextLabel)
        NSLayoutConstraint.activate([
            frequencyTextLabel.topAnchor.constraint(equalTo: nameTF.bottomAnchor, constant: 20),
            frequencyTextLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            frequencyTextLabel.heightAnchor.constraint(equalToConstant: 40),
            frequencyTextLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5)
        ])
    }
    
    func setupFrequencyPicker() {
        frequencyTextField.inputView = frequencyPicker
        
        frequencyTextField.borderStyle = .roundedRect
        frequencyTextField.backgroundColor = .systemGray6
        frequencyTextField.tintColor = frequencyTextField.backgroundColor
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

        keyboardToolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), nextButton]
        
    }
    
    @objc func frequencyPickerViewSelected() {
        self.frequencyTextField.endEditing(false)
    }
}

extension PerscriptionEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

