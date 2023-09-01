//
//  InputTextFieldFactory.swift
//  medinow
//
//  Created by Yi Xu on 7/29/23.
//

import Foundation
import UIKit

protocol InputTextFieldFactory {
    func create(placeholder: String, isEditing: Bool) -> UITextField
}


class DrugInfoTextFieldFactory: InputTextFieldFactory {
    func create(placeholder: String, isEditing: Bool = true) -> UITextField {
        let producedTF = UITextField()
        producedTF.borderStyle = .roundedRect
        producedTF.font = isEditing ? .systemFont(ofSize: 18) : .boldSystemFont(ofSize: 18)
        if (!isEditing) {
            producedTF.textColor = .white
            producedTF.layer.cornerRadius = 100
            producedTF.layer.borderColor = UIColor.white.cgColor
            
            producedTF.layer.shadowColor = UIColor.systemOrange.cgColor
            producedTF.layer.shadowOpacity = 1
            producedTF.layer.shadowOffset = .zero
            producedTF.layer.shadowRadius = 7.5
        }
        producedTF.placeholder = placeholder
        producedTF.backgroundColor = isEditing ? .systemGray6 : .systemOrange
        
        producedTF.translatesAutoresizingMaskIntoConstraints = false
        return producedTF
    }
}
