//
//  MedicineEditViewController.swift
//  medinow
//
//  Created by Yi Xu on 4/23/23.
//

import Foundation
import UIKit

class PrescriptionDetailViewController: UIViewController {
    unowned let coordinator: PrescriptionCoordinator
    let drugInfoTextFieldFactory = DrugInfoTextFieldFactory()
    let frequencyTextLabel = UILabel()
    let frequencyPicker = UIPickerView()
    let frequencyPickerOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    let drugPrescriptionService: DrugPrescriptionServiceProvider
    
    lazy var nameTF = drugInfoTextFieldFactory.create(placeholder: NSLocalizedString("Drug Name", comment: ""), isEditing: isEditing)
    lazy var frequencyTextField = drugInfoTextFieldFactory.create(placeholder: "1", isEditing: isEditing)
    
    var filledName : String?
    var filledDailyDosage: String?
    
    init(coordinator: PrescriptionCoordinator, drugPrescriptionService: DrugPrescriptionServiceProvider, filledName: String? = nil, filledDailyDosage: String? = nil) {
        self.coordinator = coordinator
        self.drugPrescriptionService = drugPrescriptionService
        
        self.filledName = filledName
        self.filledDailyDosage = filledDailyDosage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNameTF()
        setupFrequencyPicker()
        setupFrequencyLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if !editing {
            setupNonEditingNavigation()
        } else {
            setupEditingNavigation()
        }
        
        nameTF.removeFromSuperview()
        frequencyTextField.removeFromSuperview()
        nameTF = drugInfoTextFieldFactory.create(placeholder: NSLocalizedString("Drug Name", comment: ""), isEditing: isEditing)
        frequencyTextField = drugInfoTextFieldFactory.create(placeholder: "1", isEditing: isEditing)
        
        setupNameTF()
        setupFrequencyPicker()
        setupFrequencyLabel()
    }
    
    func savePrescription() {
        guard let text = nameTF.text, nameTF.text != "" else {
            let alert = UIAlertController(title: NSLocalizedString("Missing Prescription Information", comment: ""), message: NSLocalizedString("You have not filled out your prescription information.", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: .cancel))
            present(alert, animated: true)
            return
        }
        coordinator.savePrescriptionTapped(text: text, dosage: Int64(frequencyPickerOptions[frequencyPicker.selectedRow(inComponent: 0)]))
        self.dismiss(animated: true)
    }
    
    func cancelPrescriptionEdit() {
        appDelegate.coordinator.cancelPrescriptionEditTapped()
        self.dismiss(animated: true)
    }
    
    func setupNavigation() {
        self.navigationController!.navigationBar.topItem?.title = NSLocalizedString("Prescription Detail", comment: "")
        if (isEditing) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .save, primaryAction: UIAction() { [self] _ in
                self.savePrescription()
            })
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction() {
                [self] _ in
                self.cancelPrescriptionEdit()
            })
        } else {
            setupNonEditingNavigation()
        }
    }
    
    private func setupEditingNavigation() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .save, primaryAction: UIAction() { [self] _ in
            self.savePrescription()
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction() {
            [self] _ in
            self.setEditing(false, animated: true)
        })
    }
    
    private func setupNonEditingNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .edit, primaryAction: UIAction() {
            [self] _ in
            self.setEditing(true, animated: true)
        })
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .done, primaryAction: UIAction() {
            [self] _ in
            self.cancelPrescriptionEdit()
        })
    }
    
    func setupNameTF() {
        if let filledName = filledName {
            nameTF.text = filledName
        }
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
            frequencyTextLabel.bottomAnchor.constraint(equalTo: frequencyTextField.bottomAnchor),
            frequencyTextLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            frequencyTextLabel.heightAnchor.constraint(equalToConstant: 40),
            frequencyTextLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5)
        ])
    }
    
    func setupFrequencyPicker() {
        if let filledDailyDosage = filledDailyDosage {
            frequencyTextField.text = filledDailyDosage
        }
        
        if isEditing {
            frequencyTextField.inputView = frequencyPicker
        }
        frequencyTextField.delegate = self
        frequencyTextField.textAlignment = .center
        frequencyTextField.tintColor = frequencyTextField.backgroundColor
        
        frequencyPicker.translatesAutoresizingMaskIntoConstraints = false
        
        frequencyPicker.delegate = self
        frequencyPicker.dataSource = self
        
        frequencyPicker.selectRow(Int(frequencyTextField.placeholder!)! - 1, inComponent: 0, animated: false)
        frequencyTextField.text = frequencyTextField.placeholder
               
        view.addSubview(frequencyTextField)
        NSLayoutConstraint.activate([
            frequencyTextField.heightAnchor.constraint(equalToConstant: 40),
            frequencyTextField.topAnchor.constraint(equalTo: nameTF.bottomAnchor, constant: 20),
            frequencyTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
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

extension PrescriptionDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

extension PrescriptionDetailViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if (textField == nameTF) {
            NSLog("Finished Editing drug name")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return isEditing
    }
}
