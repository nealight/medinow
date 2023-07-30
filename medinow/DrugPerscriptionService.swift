//
//  DrugPerscriptionService.swift
//  medinow
//
//  Created by Yi Xu on 7/30/23.
//

import Foundation
import CoreData
import UIKit

class DrugPerscriptionService {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func fetchDrugs(fetch_offset: Int) -> [NSManagedObject] {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DrugPerscription")
        request.returnsObjectsAsFaults = false
        request.fetchLimit = fetch_offset;
        let result = try! context.fetch(request)
        return result as! [NSManagedObject]
    }
}
