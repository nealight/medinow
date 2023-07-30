//
//  DrugImageCameraController.swift
//  medinow
//
//  Created by Yi Xu on 7/22/23.
//

import Foundation
import UIKit

class DrugImageCameraController: UIImagePickerController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let coordinator = (UIApplication.shared.delegate as! AppDelegate).coordinator
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        coordinator.setInventoryDrugImage(image: info[.originalImage] as? UIImage)
    }
}
