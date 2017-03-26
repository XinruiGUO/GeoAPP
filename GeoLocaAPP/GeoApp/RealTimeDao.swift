//
//  RealTimeDao.swift
//  GeoApp
//
//  Created by Xinrui on 25/03/17.
//  Copyright © 2017 Xinrui. All rights reserved.
//

import UIKit
import CoreData

class RealTimeDao {
    
    func saveCoordinates(timestamp:Date, latitude: Double, longitude: Double) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity =  NSEntityDescription.entity(forEntityName: "Coordinate", in:managedContext)
        let item = NSManagedObject(entity: entity!, insertInto:managedContext)
        item.setValue(timestamp, forKey: "timestamp")
        item.setValue(latitude, forKey: "latitude")
        item.setValue(longitude, forKey: "longitude")
        do {
            try managedContext.save()
        } catch _ {
            print("Something went wrong.")
        }
    }

}
