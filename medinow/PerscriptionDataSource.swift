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
        fetch_offset += Rows_Each_Load
        
        drugPerscriptionService.fetchDrugsBackground(fetch_offset: fetch_offset) { (result) in
            for data in result {
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
        self.drugs.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath, ], with: .left)
        
        drugPerscriptionService.removeDrugBackground(durgName: drugs[indexPath.row].name, completionHandler: completionHandler)
    }
    

}
