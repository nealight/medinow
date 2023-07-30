//
//  DrugPerscriptionService.swift
//  medinow
//
//  Created by Yi Xu on 7/30/23.
//

import Foundation
import CoreData
import UIKit

protocol DrugPerscriptionServiceProvider {
    func fetchDrugs(fetch_offset: Int) -> [NSManagedObject]
    func fetchDrugsBackground(fetch_offset: Int, action: @escaping ([NSManagedObject]) -> ())
    func removeDrugBackground(durgName: String, completionHandler: @escaping (Bool) -> Void)
    func savePerscription(perscription: DrugPerscriptionModel)
}

class DrugPerscriptionService: DrugPerscriptionServiceProvider {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var drugPerscriptionContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    func fetchDrugs(fetch_offset: Int) -> [NSManagedObject] {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DrugPerscription")
        request.returnsObjectsAsFaults = false
        request.fetchLimit = fetch_offset;
        let result = try! context.fetch(request)
        return result as! [NSManagedObject]
    }
    
    func fetchDrugsBackground(fetch_offset: Int, action: @escaping ([NSManagedObject]) -> ()) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DrugPerscription")
        request.returnsObjectsAsFaults = false
        request.fetchLimit = fetch_offset;
        drugPerscriptionContext.perform { [action] in
            let result = try! self.drugPerscriptionContext.fetch(request)
            action(result as! [NSManagedObject])
        }
    }
    
    func removeDrugBackground(durgName: String, completionHandler: @escaping (Bool) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DrugPerscription")
        request.predicate = NSPredicate(format:"name=%@", durgName)
        drugPerscriptionContext.perform {
            let result = try! self.drugPerscriptionContext.fetch(request)
            let data = result[0]
            let object = data as! NSManagedObject
            self.drugPerscriptionContext.delete(object)
            try! self.drugPerscriptionContext.save()
            
            DispatchQueue.main.async {
                completionHandler(true)
            }
        }
    }
    
    func savePerscription(perscription: DrugPerscriptionModel) {
        let entity = NSEntityDescription.entity(forEntityName: "DrugPerscription", in: drugPerscriptionContext)
        let newDrug = NSManagedObject(entity: entity!, insertInto: drugPerscriptionContext)
        newDrug.setValue(perscription.name, forKey: "name")
        newDrug.setValue(perscription.dailyDosage, forKey: "dailyDosage")
        try! drugPerscriptionContext.save()
    }
}
