//
//  DrugPrescriptionService.swift
//  medinow
//
//  Created by Yi Xu on 7/30/23.
//

import Foundation
import CoreData
import UIKit

protocol DrugPrescriptionServiceProvider {
    func fetchDrugsBackground(fetch_offset: Int, action: @escaping ([NSManagedObject]) -> ())
    func removeDrugBackground(drugName: String, completionHandler: @escaping (Bool) -> Void)
    func insertPrescription(prescription: DrugPrescriptionModel)
    func fetchDrug(for name: String, action: @escaping (NSManagedObject) -> ())
}

class DrugPrescriptionService: DrugPrescriptionServiceProvider {
    func fetchDrug(for drugName: String, action: @escaping (NSManagedObject) -> ()) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DrugPrescription")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format:"name=%@", drugName)
        drugPrescriptionContext.perform {
            let result = try! self.drugPrescriptionContext.fetch(request)
            let data = result.first
            let object = data as! NSManagedObject
            
            DispatchQueue.main.async {
                action(object)
            }
        }
    }
    
    lazy var drugPrescriptionContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    
    func fetchDrugsBackground(fetch_offset: Int, action: @escaping ([NSManagedObject]) -> ()) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DrugPrescription")
        request.returnsObjectsAsFaults = false
        request.fetchLimit = fetch_offset;
        drugPrescriptionContext.perform { [action] in
            let result = try! self.drugPrescriptionContext.fetch(request)
            action(result as! [NSManagedObject])
        }
    }
    
    func removeDrugBackground(drugName: String, completionHandler: @escaping (Bool) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DrugPrescription")
        request.predicate = NSPredicate(format:"name=%@", drugName)
        drugPrescriptionContext.perform {
            let result = try! self.drugPrescriptionContext.fetch(request)
            let data = result.first
            let object = data as! NSManagedObject
            self.drugPrescriptionContext.delete(object)
            try! self.drugPrescriptionContext.save()
            
            DispatchQueue.main.async {
                completionHandler(true)
            }
        }
    }
    
    func insertPrescription(prescription: DrugPrescriptionModel) {
        let entity = NSEntityDescription.entity(forEntityName: "DrugPrescription", in: drugPrescriptionContext)
        let newDrug = NSManagedObject(entity: entity!, insertInto: drugPrescriptionContext)
        newDrug.setValue(prescription.name, forKey: "name")
        newDrug.setValue(prescription.dailyDosage, forKey: "dailyDosage")
        try! drugPrescriptionContext.save()
    }
    
    func editPrescription(prescription: DrugPrescriptionModel, originalName: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DrugPrescription")
        request.predicate = NSPredicate(format:"name=%@", originalName)
        drugPrescriptionContext.perform {
            let result = try! self.drugPrescriptionContext.fetch(request)
            let data = result.first!
            let existingDrug = data as! NSManagedObject
            existingDrug.setValue(prescription.name, forKey: "name")
            existingDrug.setValue(prescription.dailyDosage, forKey: "dailyDosage")
            try! self.drugPrescriptionContext.save()
        }
    }
}

