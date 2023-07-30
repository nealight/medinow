//
//  Drug.swift
//  medinow
//
//  Created by Yi Xu on 5/9/23.
//

import Foundation

struct DrugInventoryModel: Hashable {
    let snapshot: Data?
    let name: String
    let expirationDate: Date
    let originalQuantity: Int64
    let remainingQuantity: Int64
}
