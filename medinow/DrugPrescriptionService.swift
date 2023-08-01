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
    func removeDrugBackground(durgName: String, completionHandler: @escaping (Bool) -> Void)
    func savePrescription(prescription: DrugPrescriptionModel)
}

class DrugPrescriptionService: DrugPrescriptionServiceProvider {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
    
    func removeDrugBackground(durgName: String, completionHandler: @escaping (Bool) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DrugPrescription")
        request.predicate = NSPredicate(format:"name=%@", durgName)
        drugPrescriptionContext.perform {
            let result = try! self.drugPrescriptionContext.fetch(request)
            let data = result[0]
            let object = data as! NSManagedObject
            self.drugPrescriptionContext.delete(object)
            try! self.drugPrescriptionContext.save()
            
            DispatchQueue.main.async {
                completionHandler(true)
            }
        }
    }
    
    func savePrescription(prescription: DrugPrescriptionModel) {
        let entity = NSEntityDescription.entity(forEntityName: "DrugPrescription", in: drugPrescriptionContext)
        let newDrug = NSManagedObject(entity: entity!, insertInto: drugPrescriptionContext)
        newDrug.setValue(prescription.name, forKey: "name")
        newDrug.setValue(prescription.dailyDosage, forKey: "dailyDosage")
        try! drugPrescriptionContext.save()
    }
}
