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
    func fetchInventoryDetailsBackground(fetch_offset: Int?, action: @escaping ([NSManagedObject]) -> ())
    func saveDrugInventory(drugInventory: DrugInventoryModel)
    func removeDrugInventory(drugName: String, completionHandler: @escaping (Bool) -> Void)
}

extension InventoryServiceProvider {
    func fetchInventoryDetailBackground(action: @escaping ([NSManagedObject]) -> ()) {
        return fetchInventoryDetailsBackground(fetch_offset: nil, action: action)
    }
}

class InventoryService: InventoryServiceProvider {
    func removeDrugInventory(drugName: String, completionHandler: @escaping (Bool) -> Void) {
        // TO BE DONE
        return
    }
    
    lazy var drugInventoryContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    
    func fetchInventoryDetailsBackground(fetch_offset: Int?, action: @escaping ([NSManagedObject]) -> ()) {
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
        
        newDrug.setValue(drugInventory.uuid, forKey: "uuid")
        newDrug.setValue(drugInventory.name, forKey: "name")
        newDrug.setValue(drugInventory.remainingQuantity, forKey: "remainingQuantity")
        newDrug.setValue(drugInventory.originalQuantity, forKey: "originalQuantity")
        newDrug.setValue(drugInventory.snapshot, forKey: "snapshot")
        drugInventoryContext.perform {
            try! self.drugInventoryContext.save()
        }
    }
}
