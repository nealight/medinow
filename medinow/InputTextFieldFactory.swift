//
//  InputTextFieldFactory.swift
//  medinow
//
//  Created by Yi Xu on 7/29/23.
//

import Foundation
import UIKit

protocol InputTextFieldFactory {
    func create(placeholder: String, text: String, isEditing: Bool) -> UITextField
}

extension InputTextFieldFactory {
    func create(placeholder: String, text: String = "", isEditing: Bool = true) -> UITextField {
        return create(placeholder: placeholder, text: text, isEditing: isEditing)
    }
}

class DrugInfoTextFieldFactory: InputTextFieldFactory {
    func create(placeholder: String, text: String, isEditing: Bool = true) -> UITextField {
        let producedTF = UITextField()
        producedTF.borderStyle = .roundedRect
        
        producedTF.attributedPlaceholder = .init(string: placeholder, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.systemOrange.withAlphaComponent(0.5)
        ])
        producedTF.layer.cornerRadius = 10
        producedTF.clipsToBounds = true
        
        if (isEditing) {
            producedTF.layer.borderColor = UIColor.systemOrange.cgColor
            producedTF.layer.borderWidth = 1
            producedTF.font = .systemFont(ofSize: 18, weight: .semibold)
            producedTF.text = text
        } else {
            producedTF.textColor = .white
            producedTF.layer.borderColor = UIColor.white.cgColor
            producedTF.backgroundColor = .systemOrange
            producedTF.font = .boldSystemFont(ofSize: 18)
            producedTF.text = producedTF.placeholder
        }
        
        producedTF.translatesAutoresizingMaskIntoConstraints = false
        return producedTF
    }
}
