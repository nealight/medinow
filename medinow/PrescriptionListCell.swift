//
//  MedicationListCell.swift
//  medinow
//
//  Created by Yi Xu on 4/23/23.
//

import Foundation
import UIKit

class PrescriptionListCell: UITableViewCell {
    static let CellTouchOnAnimationDuration = 0.2
    
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
                label.font = UIFont.boldSystemFont(ofSize: 30)
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
    }()
    let dosageLabel: UILabel = {
        let label = UILabel()
                label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
    }()
    
    lazy var cellViewLeftMargin: NSLayoutConstraint = cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: PrescriptionListCell.CellTouchOnAnimationDuration) {
            self.cellView.backgroundColor = .systemOrange.withAlphaComponent(0.5)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: PrescriptionListCell.CellTouchOnAnimationDuration) {
            self.cellView.backgroundColor = .systemOrange.withAlphaComponent(1)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: PrescriptionListCell.CellTouchOnAnimationDuration, delay: 0.5) {
            self.cellView.backgroundColor = .systemOrange.withAlphaComponent(1)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
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
        
        cellView.layer.shadowColor = UIColor.systemOrange.cgColor
        cellView.layer.shadowOpacity = 1
        cellView.layer.shadowOffset = .zero
        cellView.layer.shadowRadius = 7.5
        
        addSubview(cellView)
        cellView.addSubview(medicationLabel)
        cellView.addSubview(dosageLabel)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            cellViewLeftMargin,
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            medicationLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 20),
            medicationLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: 20),
            medicationLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 15)
        ])
        
        NSLayoutConstraint.activate([
            dosageLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 20),
            dosageLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: 20),
            dosageLabel.topAnchor.constraint(equalTo: medicationLabel.bottomAnchor, constant: 7.5)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
