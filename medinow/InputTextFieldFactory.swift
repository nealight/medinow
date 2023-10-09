//
//  InputTextFieldFactory.swift
//  medinow
//
//  Created by Yi Xu on 7/29/23.
//

import Foundation
import UIKit

protocol InputTextField: UIView {
    var textFieldView: UITextField! { get }
}

class DrugInfoTextField: UIView, InputTextField {
    var textFieldView: UITextField!
}

protocol InputTextFieldFactory {
    func create(placeholder: String, text: String, isEditing: Bool) -> InputTextField
}

extension InputTextFieldFactory {
    func create(placeholder: String, text: String = "", isEditing: Bool = true) -> InputTextField {
        return create(placeholder: placeholder, text: text, isEditing: isEditing)
    }
}

class DrugInfoTextFieldFactory: InputTextFieldFactory {
    func create(placeholder: String, text: String, isEditing: Bool = true) -> InputTextField {
        let overlayingView = DrugInfoTextField()
        overlayingView.layer.masksToBounds = false
        
        
        let producedTF = UITextField(frame: overlayingView.bounds)
        producedTF.borderStyle = .roundedRect
        
        producedTF.attributedPlaceholder = .init(string: placeholder, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.systemOrange.withAlphaComponent(0.5)
        ])
        producedTF.layer.cornerRadius = 5
        producedTF.layer.masksToBounds = true
        
        overlayingView.addSubview(producedTF)
        overlayingView.textFieldView = producedTF
        
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
            
            overlayingView.layer.shadowColor = UIColor.systemOrange.cgColor
            overlayingView.layer.shadowOpacity = 1
            overlayingView.layer.shadowOffset = .zero
            overlayingView.layer.shadowRadius = 10
        }
        overlayingView.translatesAutoresizingMaskIntoConstraints = false
        producedTF.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return overlayingView
    }
}
