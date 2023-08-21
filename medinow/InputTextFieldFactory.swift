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
        if (isEditing) {
            producedTF.returnKeyType = .done
            producedTF.font = .systemFont(ofSize: 18, weight: .regular)
        } else {
            producedTF.minimumFontSize = 18
            producedTF.font = .systemFont(ofSize: 18, weight: .medium)
        }
        producedTF.placeholder = placeholder
        producedTF.borderStyle = .roundedRect
        producedTF.backgroundColor = isEditing ? .systemGray6 : .clear

        producedTF.translatesAutoresizingMaskIntoConstraints = false
        return producedTF
    }
}
