//
//  InscriptionDao.swift
//  GeoApp
//
//  Created by Xinrui on 26/03/17.
//  Copyright © 2017 Xinrui. All rights reserved.
//

import UIKit
import CoreData

class InscriptionDao {
    
    func saveCoordinates(mailAddress:String, pass: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity =  NSEntityDescription.entity(forEntityName: "User", in:managedContext)
        let item = NSManagedObject(entity: entity!, insertInto:managedContext)
        item.setValue(mailAddress, forKey: "email")
        item.setValue(pass, forKey: "password")
        
        do {
            try managedContext.save()
        } catch _ {
            print("Something went wrong.")
        }
    }

}
