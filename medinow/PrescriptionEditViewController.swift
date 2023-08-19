//
//  MedicineEditViewController.swift
//  medinow
//
//  Created by Yi Xu on 4/23/23.
//

import Foundation
import UIKit

class PrescriptionEditViewController: UIViewController, UITextFieldDelegate {
    lazy var coordinator = appDelegate.coordinator
    let drugInfoTextFieldFactory = DrugInfoTextFieldFactory()
    let frequencyTextLabel = UILabel()
    let frequencyPicker = UIPickerView()
    let frequencyPickerOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    let drugPrescriptionService: DrugPrescriptionServiceProvider
    
    lazy var nameTF = drugInfoTextFieldFactory.create(placeholder: NSLocalizedString("Drug Name", comment: ""))
    lazy var frequencyTextField = drugInfoTextFieldFactory.create(placeholder: "1")
    
    init(drugPrescriptionService: DrugPrescriptionServiceProvider) {
        self.drugPrescriptionService = drugPrescriptionService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigation()
        setupNameTF()
        setupFrequencyLabel()
        setupFrequencyPicker()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if (textField == nameTF) {
            NSLog("Finished Editing drug name")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func savePrescription() {
        guard let text = nameTF.text, nameTF.text != "" else {
            return
        }
        coordinator.savePrescriptionTapped(text: text, dosage: Int64(frequencyPickerOptions[frequencyPicker.selectedRow(inComponent: 0)]))
    }
    
    func cancelPrescriptionEdit() {
        appDelegate.coordinator.cancelPrescriptionEditTapped()
    }
    
    func setupNavigation() {
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("Prescription Detail", comment: "")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .save, primaryAction: UIAction() { [self] _ in
            self.savePrescription()
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction() {
            [self] _ in
            self.cancelPrescriptionEdit()
        })
    }
    
    
    func setupNameTF() {
        nameTF.delegate = self
        view.addSubview(nameTF)
        NSLayoutConstraint.activate([
            nameTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameTF.heightAnchor.constraint(equalToConstant: 40),
            nameTF.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            nameTF.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupFrequencyLabel() {
        frequencyTextLabel.text = NSLocalizedString("Pills per day", comment: "")
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
        frequencyTextField.textAlignment = .center
        frequencyTextField.tintColor = frequencyTextField.backgroundColor
        
        frequencyPicker.translatesAutoresizingMaskIntoConstraints = false
        
        frequencyPicker.dataSource = self
        frequencyPicker.delegate = self
        
        frequencyPicker.selectRow(Int(frequencyTextField.placeholder!)! - 1, inComponent: 0, animated: false)
        frequencyTextField.text = frequencyTextField.placeholder
               
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

extension PrescriptionEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

