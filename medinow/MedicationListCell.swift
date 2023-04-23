//
//  MedicationListCell.swift
//  medinow
//
//  Created by Yi Xu on 4/23/23.
//

import Foundation
import UIKit

class MedicationListCell: UITableViewCell {
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let medicationLabel: UILabel = {
        let label = UILabel()
                label.text = "Tylenol"
                label.textColor = UIColor.white
                label.font = UIFont.boldSystemFont(ofSize: 16)
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    func setupView() {
        addSubview(cellView)
        cellView.addSubview(medicationLabel)
        
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            medicationLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 20),
            medicationLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            medicationLabel.centerXAnchor.constraint(equalTo: cellView.centerXAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
