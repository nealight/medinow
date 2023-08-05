//
//  InputTextFieldFactory.swift
//  medinow
//
//  Created by Yi Xu on 7/29/23.
//

import Foundation
import UIKit

protocol InputTextFieldFactory {
    func create(placeholder: String) -> UITextField
}

class DrugInfoTextFieldFactory: InputTextFieldFactory {
    func create(placeholder: String) -> UITextField {
        let nameTF = UITextField()
        nameTF.returnKeyType = .done
        
        nameTF.text = placeholder
        nameTF.minimumFontSize = 20
        nameTF.borderStyle = .roundedRect
        nameTF.backgroundColor = .systemGray6

        nameTF.translatesAutoresizingMaskIntoConstraints = false
        return nameTF
    }
}
