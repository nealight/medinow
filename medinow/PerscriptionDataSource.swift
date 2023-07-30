//
//  PerscriptionDataSource.swift
//  medinow
//
//  Created by Yi Xu on 5/9/23.
//

import Foundation
import UIKit
import CoreData

class PerscriptionDataSource: NSObject, UITableViewDataSource {
    var fetch_offset = 0
    let Rows_Each_Load = 20
    let drugPerscriptionService: DrugPerscriptionService
    
    init(fetch_offset: Int = 0, drugPerscriptionService: DrugPerscriptionService) {
        self.drugPerscriptionService = drugPerscriptionService
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var drugs: Array<DrugPerscriptionModel> = initializeDrugs()
    
    
    func initializeDrugs() -> Array<DrugPerscriptionModel> {
        var fetched_drugs: [DrugPerscriptionModel] = []
        fetch_offset += Rows_Each_Load
        let result = drugPerscriptionService.fetchDrugs(fetch_offset: fetch_offset)
        for data in result {
            fetched_drugs.append(DrugPerscriptionModel(name: data.value(forKey: "name") as! String, dailyDosage: data.value(forKey: "dailyDosage") as! Int64))
        }
        return fetched_drugs
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugs.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PerscriptionListCell", for: indexPath) as! PerscriptionListCell
        cell.medicationLabel.text = drugs[indexPath.row].name
        
        let dailyDosage = drugs[indexPath.row].dailyDosage
        cell.dosageLabel.text = "\(dailyDosage) pill\(dailyDosage == 1 ? "" : "s") per day"
        
        if (indexPath.row == drugs.count - 1) {
            loadTableData(tableView)
        }
        
        return cell
    }
    
    func loadTableData(_ tableView: UITableView) {
        var fetched_drugs: [DrugPerscriptionModel] = []
        let context = appDelegate.persistentContainer.newBackgroundContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DrugPerscription")
        request.returnsObjectsAsFaults = false
        fetch_offset += Rows_Each_Load
        request.fetchLimit = fetch_offset;
        context.perform {
            let result = try! context.fetch(request)
            for data in result as! [NSManagedObject] {
                fetched_drugs.append(DrugPerscriptionModel(name: data.value(forKey: "name") as! String, dailyDosage: data.value(forKey: "dailyDosage") as! Int64))
            }
            if self.drugs != fetched_drugs {
                self.drugs = fetched_drugs
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }
        }
    }
    
    func deleteRowAt(_ tableView: UITableView, indexPath: IndexPath, completionHandler: @escaping (Bool) -> Void) {
        NSLog("[\(type(of: self))] delete detected!")
        let context = self.appDelegate.persistentContainer.newBackgroundContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DrugPerscription")
        request.predicate = NSPredicate(format:"name=%@", drugs[indexPath.row].name)
        context.perform {
            let result = try! context.fetch(request)
            let data = result[0]
            let object = data as! NSManagedObject
            context.delete(object)
            try! context.save()
            
            self.drugs.remove(at: indexPath.row)
            DispatchQueue.main.async {
                tableView.deleteRows(at: [indexPath, ], with: .left)
                completionHandler(true)
            }
        }
    }
    

}
