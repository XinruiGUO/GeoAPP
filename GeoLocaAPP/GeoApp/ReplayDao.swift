//
//  ReplayDao.swift
//  GeoApp
//
//  Created by Xinrui on 25/03/17.
//  Copyright © 2017 Xinrui. All rights reserved.
//

import UIKit
import CoreData

class ReplayDao {
    
    typealias Point = (Double, Double, Date)
    
    let googleMapView = GoogleMapView()
    
    
    func fetchAndPrintEachCoordinate(startTm: Date, endTm: Date) -> [Point] {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Coordinate>(entityName: "Coordinate")
        
        //Filter coordinates
        let datePredicate = NSPredicate(format: "timestamp >= %@ && timestamp <= %@", startTm as NSDate, endTm as NSDate)
        print(startTm, ", ", endTm)
        
        fetchRequest.predicate = datePredicate
        
        let sectionSortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        var coordinates: [Point] = []
        
        do {
            
            let fetchedResults = try managedContext.fetch(fetchRequest)
            for item in fetchedResults {
                print(item.value(forKey: "timestamp")!,", ", item.value(forKey: "latitude")!,", ", item.value(forKey: "longitude")!)
                let point : Point = (item.value(forKey: "latitude") as! Double, item.value(forKey: "longitude") as! Double,item.value(forKey: "timestamp") as! Date)
                coordinates.append(point)
            }
            
            return coordinates
            //googleMapView.drawPolylineWithPointArray(coordinates: coordinates)

        } catch let error as NSError {
            print(error.description)
        }
        return []
    }
}
