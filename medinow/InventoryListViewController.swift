//
//  InventoryListViewController.swift
//  medinow
//
//  Created by Yi Xu on 5/7/23.
//

import Foundation
import UIKit

class InventoryListViewController: UICollectionViewController {
    let coordinator = (UIApplication.shared.delegate as! AppDelegate).coordinator!
    let cellReuseID = "InventoryCell"
    private lazy var dataSource = makeDataSource()
    
    enum Section: Int, CaseIterable {
        case unexpired
        case expired
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
    }
    
    func setupView() {
        self.view.backgroundColor = .systemBackground
        self.collectionView.register(InventoryCell.self, forCellWithReuseIdentifier: cellReuseID)
        self.collectionView.dataSource = dataSource
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, DrugInventoryModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([.init(name: "Vitamin C", expirationDate: Date(), originalQuantity: 0, remainingQuantity: 0), ], toSection: .unexpired)
        snapshot.appendItems([.init(name: "Vitamin D", expirationDate: Date(), originalQuantity: 0, remainingQuantity: 0), ], toSection: .unexpired)
        dataSource.apply(snapshot)
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, DrugInventoryModel> {
            UICollectionViewDiffableDataSource(
                collectionView: collectionView,
                cellProvider: { collectionView, indexPath, product in
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: self.cellReuseID,
                        for: indexPath
                    ) as! InventoryCell
                    return cell
                }
            )
        }
    
    func setupNavigation() {
        let addButtonAction = UIAction() { _ in
            self.coordinator.addInventoryTapped()
        }
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: addButtonAction)
    }
}

//extension InventoryListViewController {
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 8
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath)
//
//        cell.backgroundColor = .systemCyan
//        return cell
//    }
//}
