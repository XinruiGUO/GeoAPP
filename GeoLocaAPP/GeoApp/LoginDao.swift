//
//  LoginDao.swift
//  GeoApp
//
//  Created by Xinrui on 25/03/17.
//  Copyright © 2017 Xinrui. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class LoginDao {
    func fetchAndPrintUser(email: String, password: String) -> Bool {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        
        /*
        do {
            
            let fetchedResults = try managedContext.fetch(fetchRequest)
            for item in fetchedResults {
                print("CoreDta :",item)
            }
            
        } catch let error as NSError {
            print(error.description)
        }
        */
        
        
        //Filter users
        let userPredicate = NSPredicate(format: "email == %@", email)
        fetchRequest.predicate = userPredicate
        
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            for item in fetchedResults {
                return item.value(forKey: "email") as! String == email && item.value(forKey: "password") as! String == password
            }
        } catch let error as NSError {
            print(error.description)
        }
        return false
    }

}
