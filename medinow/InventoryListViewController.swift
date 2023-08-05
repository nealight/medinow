//
//  InventoryListViewController.swift
//  medinow
//
//  Created by Yi Xu on 5/7/23.
//

import Foundation
import UIKit

class InventoryListViewController: UICollectionViewController {
    lazy var coordinator = appDelegate.coordinator
    let cellReuseID = "InventoryCell"
    let inventoryService: InventoryServiceProvider
    private lazy var dataSource = makeDataSource()
    
    enum Section: Int, CaseIterable {
        case unexpired
        case expired
    }
    
    init(inventoryService: InventoryServiceProvider, collectionViewLayout: UICollectionViewLayout) {
        self.inventoryService = inventoryService
        super.init(collectionViewLayout: collectionViewLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupDataSource()
        setupView()
    }
    
    func setupView() {
        self.view.backgroundColor = .systemBackground
        self.collectionView.register(InventoryCell.self, forCellWithReuseIdentifier: cellReuseID)
    }
    
    func setupDataSource() {
        self.collectionView.dataSource = dataSource
        var snapshot = NSDiffableDataSourceSnapshot<Section, DrugInventoryModel>()
        snapshot.appendSections(Section.allCases)
    
        var fetched_drugs: [DrugInventoryModel] = []
        
        inventoryService.fetchInventoryDetailBackground() { (result) in
            for data in result {
                fetched_drugs.append(DrugInventoryModel(snapshot: data.value(forKey: "snapshot") as? Data, name: data.value(forKey: "name") as! String, expirationDate: Date(), originalQuantity: data.value(forKey: "originalQuantity") as! Int64, remainingQuantity: data.value(forKey: "remainingQuantity") as! Int64))
            }
            snapshot.appendItems(fetched_drugs)
            DispatchQueue.main.async {
                self.dataSource.apply(snapshot)
            }
        }
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, DrugInventoryModel> {
            UICollectionViewDiffableDataSource(
                collectionView: collectionView,
                cellProvider: { collectionView, indexPath, product in
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: self.cellReuseID,
                        for: indexPath
                    ) as! InventoryCell
                    if let snapshot = product.snapshot {
                        cell.medicationLabel.text = product.name
                        cell.drugImage = UIImage(data: snapshot)
                    }
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
