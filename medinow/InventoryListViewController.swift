//
//  InventoryListViewController.swift
//  medinow
//
//  Created by Yi Xu on 5/7/23.
//

import Foundation
import UIKit
import CoreData

class InventoryListViewController: UICollectionViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var coordinator = appDelegate.coordinator
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
        
        var fetched_drugs: [DrugInventoryModel] = []
        let context = appDelegate.persistentContainer.newBackgroundContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DrugInventory")
        request.returnsObjectsAsFaults = false
        
        context.perform {
            let result = try! context.fetch(request)
            for data in result as! [NSManagedObject] {
                fetched_drugs.append(DrugInventoryModel(snapshot: data.value(forKey: "snapshot") as? Data, name: data.value(forKey: "name") as! String, expirationDate: Date(), originalQuantity: data.value(forKey: "originalQuantity") as! Int64, remainingQuantity: data.value(forKey: "remainingQuantity") as! Int64))
            }
            snapshot.appendItems(fetched_drugs)
            self.dataSource.apply(snapshot)
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
