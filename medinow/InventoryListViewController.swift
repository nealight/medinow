//
//  InventoryListViewController.swift
//  medinow
//
//  Created by Yi Xu on 5/7/23.
//

import Foundation
import UIKit

class InventoryListViewController: UICollectionViewController {
    unowned let coordinator: InventoryCoordinator
    let cellReuseID = "InventoryCell"
    let inventoryService: InventoryServiceProvider
    private lazy var dataSource = makeDataSource()
    var fetched_drugs: [DrugInventoryModel] = []
    
    enum Section: Int, CaseIterable {
        case unexpired
        case expired
    }
    
    init(coordinator: InventoryCoordinator, inventoryService: InventoryServiceProvider, collectionViewLayout: UICollectionViewLayout) {
        self.coordinator = coordinator
        self.inventoryService = inventoryService
        super.init(collectionViewLayout: collectionViewLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        setupDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        reloadDrugInventoryData()
    }
    
    func setupView() {
        self.view.backgroundColor = .systemBackground
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(InventoryCell.self, forCellWithReuseIdentifier: cellReuseID)
    }
    
    func setupDataSource() {
        self.collectionView.dataSource = dataSource
    }
    
    func reloadDrugInventoryData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DrugInventoryModel>()
        snapshot.appendSections(Section.allCases)
        inventoryService.fetchInventoryDetailBackground() { [weak self] (result) in
            self?.fetched_drugs = []
            for data in result {
                self?.fetched_drugs.append(DrugInventoryModel(uuid: data.value(forKey: "uuid") as! UUID, snapshot: data.value(forKey: "snapshot") as? Data, name: data.value(forKey: "name") as! String, expirationDate: Date(), originalQuantity: data.value(forKey: "originalQuantity") as! Int64, remainingQuantity: data.value(forKey: "remainingQuantity") as! Int64))
            }
            snapshot.appendItems(self?.fetched_drugs ?? [])
            DispatchQueue.main.async {
                self?.dataSource.apply(snapshot)
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: addButtonAction)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let drug = self.fetched_drugs[indexPath.item]
        self.navigationController?.pushViewController(InventoryDetailViewController(coordinator: coordinator, inventoryService: inventoryService, name: drug.name, quantity: String(drug.remainingQuantity)), animated: true)
        
    }
}
