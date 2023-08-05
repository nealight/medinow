//
//  InventoryService.swift
//  Cappie
//
//  Created by Yi Xu on 8/5/23.
//

import Foundation
import CoreData
import UIKit

protocol InventoryServiceProvider {
    func fetchInventoryDetailBackground(fetch_offset: Int?, action: @escaping ([NSManagedObject]) -> ())
    func saveDrugInventory(drugInventory: DrugInventoryModel)
}

extension InventoryServiceProvider {
    func fetchInventoryDetailBackground(action: @escaping ([NSManagedObject]) -> ()) {
        return fetchInventoryDetailBackground(fetch_offset: nil, action: action)
    }
}

class InventoryService: InventoryServiceProvider {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var drugInventoryContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    
    func fetchInventoryDetailBackground(fetch_offset: Int?, action: @escaping ([NSManagedObject]) -> ()) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DrugInventory")
        request.returnsObjectsAsFaults = false
        if let fetch_offset = fetch_offset {
            request.fetchLimit = fetch_offset;
        }
        drugInventoryContext.perform { [action] in
            let result = try! self.drugInventoryContext.fetch(request)
            action(result as! [NSManagedObject])
        }
    }
    
    func saveDrugInventory(drugInventory: DrugInventoryModel) {
        let entity = NSEntityDescription.entity(forEntityName: "DrugInventory", in: drugInventoryContext)
        let newDrug = NSManagedObject(entity: entity!, insertInto: drugInventoryContext)
        
        newDrug.setValue(drugInventory.name, forKey: "name")
        newDrug.setValue(drugInventory.remainingQuantity, forKey: "remainingQuantity")
        newDrug.setValue(drugInventory.originalQuantity, forKey: "originalQuantity")
        newDrug.setValue(drugInventory.snapshot, forKey: "snapshot")
        drugInventoryContext.perform {
            try! self.drugInventoryContext.save()
        }
    }
}
