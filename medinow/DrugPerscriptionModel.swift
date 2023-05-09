//
//  DrugPerscriptionModel.swift
//  medinow
//
//  Created by Yi Xu on 4/25/23.
//
import CoreData
import Foundation

struct DrugPerscriptionModel: Codable, Equatable, Hashable {
    let name: String;
    let dailyDosage: Int64;
}
