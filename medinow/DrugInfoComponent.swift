//
//  DrugInfoComponent.swift
//  Cappie
//
//  Created by Yi Xu on 9/4/23.
//

import Foundation
import UIKit

protocol InfoComponentFactory {
    typealias Component = UIView
    func create(leftView: InfoComponentFactory.Component, rightView: InfoComponentFactory.Component, isEditing: Bool) -> Component
}

class DrugInfoComponentFactory: InfoComponentFactory {
    func create(leftView: InfoComponentFactory.Component, rightView: InfoComponentFactory.Component, isEditing: Bool) -> InfoComponentFactory.Component {
        let result = InfoComponentFactory.Component()
        
        result.translatesAutoresizingMaskIntoConstraints = false
        result.addSubview(leftView)
        result.addSubview(rightView)
        let leftViewConstraints = [
            leftView.leadingAnchor.constraint(equalTo: result.leadingAnchor, constant: 10),
            leftView.widthAnchor.constraint(equalTo: result.widthAnchor, multiplier: 0.5, constant: -40),
            leftView.heightAnchor.constraint(equalToConstant: 40),
            leftView.centerYAnchor.constraint(equalTo: result.centerYAnchor)
        ]
        let rightViewConstraints = [
            rightView.trailingAnchor.constraint(equalTo: result.trailingAnchor, constant: -0),
            rightView.heightAnchor.constraint(equalTo: leftView.heightAnchor),
            rightView.widthAnchor.constraint(equalTo: leftView.widthAnchor),
            rightView.centerYAnchor.constraint(equalTo: leftView.centerYAnchor)
        ]
        
        result.addConstraints(rightViewConstraints)
        result.addConstraints(leftViewConstraints)
        
        result.backgroundColor = .systemOrange.withAlphaComponent(0.15)
        result.layer.cornerRadius = 10
        
        return result
    }
}

