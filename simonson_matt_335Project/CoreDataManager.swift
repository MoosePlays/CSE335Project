//
//  CoreDataManager.swift
//  simonson_matt_335Project
//
//  Created by Michael Figueroa on 4/16/20.
//  Copyright © 2020 mjsimons. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    let appDelegate: AppDelegate
    let context: NSManagedObjectContext
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    func addLocation(name: String){
        //create container and set destination
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: context)
        let newLocation = NSManagedObject(entity: entity!, insertInto: context)
        
        //set values
        newLocation.setValue(name, forKey: "name")
        
        //save data
        do {
            try context.save()
        } catch {
            print("something wrong")
        }
    }
    
    func addRoute(name: String, type: Bool, grade: Int16, desc: String, photo: NSData){
        //create container and set destination
        let entity = NSEntityDescription.entity(forEntityName: "Route", in: context)
        let newRoute = NSManagedObject(entity: entity!, insertInto: context)
        
        //set values
        newRoute.setValue(name, forKey: "name")
        newRoute.setValue(type, forKey: "type")
        newRoute.setValue(grade, forKey: "grade")
        newRoute.setValue(desc, forKey: "desc")
        newRoute.setValue(photo, forKey: "photo")
    }
    
}
