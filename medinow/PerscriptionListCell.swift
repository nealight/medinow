//
//  MedicationListCell.swift
//  medinow
//
//  Created by Yi Xu on 4/23/23.
//

import Foundation
import UIKit

class PerscriptionListCell: UITableViewCell {
    var cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let medicationLabel: UILabel = {
        let label = UILabel()
                label.textColor = UIColor.white
                label.font = UIFont.boldSystemFont(ofSize: 20)
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
    }()
    
    lazy var cellViewLeftMargin: NSLayoutConstraint = cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            cellView.backgroundColor = .systemOrange.withAlphaComponent(0.5)
        } else {
            cellView.backgroundColor = .systemOrange.withAlphaComponent(1)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
//        if editingStyle == .delete {
//            return
//        }
        if editing {
            UIView.animate(withDuration: 0.2, animations: {
                self.cellViewLeftMargin.constant = 60;
                self.layoutIfNeeded();
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {super.setEditing(editing, animated: animated)})
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.cellViewLeftMargin.constant = 10;
                self.layoutIfNeeded();
            })
            super.setEditing(editing, animated: animated)
        }
    }
    
    func setupView() {
        self.selectionStyle = .none
        
        addSubview(cellView)
        cellView.addSubview(medicationLabel)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            cellViewLeftMargin,
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
