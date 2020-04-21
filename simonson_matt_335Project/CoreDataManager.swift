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
    
    //MARK: - Add to CoreData
    
    func addLocation(name: String) -> NSManagedObject{
        //create container and set destination
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: context)
        let newLocation = NSManagedObject(entity: entity!, insertInto: context)
        
        //set values
        newLocation.setValue(name, forKey: "name")
        
        //save data
        do {
            try context.save()
        } catch {
            print("something wrong in adding location")
        }
        
        return newLocation
    }
    
    func addRoute(name: String, type: Bool, grade: Int16, desc: String, photo: NSData) -> NSManagedObject{
        //create container and set destination
        let entity = NSEntityDescription.entity(forEntityName: "Route", in: context)
        let newRoute = NSManagedObject(entity: entity!, insertInto: context)
        
        //set values
        newRoute.setValue(name, forKey: "name")
        newRoute.setValue(type, forKey: "type") // BOOL data, false = bouldering, true = rope (toprope and lead combined for now)
        newRoute.setValue(grade, forKey: "grade")
        newRoute.setValue(desc, forKey: "desc")
        newRoute.setValue(photo, forKey: "photo") // UIImage(data:imageData,scale:1.0) and image.pngData() for convert
        
        //save data
        do {
            try context.save()
        } catch {
            print("somethings wrong in adding route")
        }
        
        return newRoute
    }
    
    func setProfileData(name: String, photo: NSData) -> NSManagedObject{
        //create container and set destination
        let profile = fetchProfile()
        if profile == []{ // create new profile
            //create container and set destination
            let entity = NSEntityDescription.entity(forEntityName: "ProfileData", in: context)
            let newProfile = NSManagedObject(entity: entity!, insertInto: context)
            
            //set values
            newProfile.setValue(name, forKey: "name")
            newProfile.setValue(photo, forKey: "photo")
            
            //save data
            do{
                try context.save()
            } catch {
                print("somethings wrong in setting new profile")
            }
            
            return newProfile
            
        } else { // edit existing profile
            //get profile as NSManagedObject
            let editedProfile: NSManagedObject = profile[0]
            
            //set new values
            editedProfile.setValue(name, forKey: "name")
            editedProfile.setValue(photo, forKey: "photo")
            
            //save data
            do{
                try context.save()
            } catch {
                print("something wrong in editing profile")
            }
            
            return editedProfile
        }
    }
    
    //MARK: - Fetch from CoreData
    func fetchLocations() -> [NSManagedObject]{
        //create array and set fetch request info
        var locations: [NSManagedObject] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Location")
        
        //fetch data
        do{
            locations = try context.fetch(fetchRequest)
        } catch let error as NSError{
            print("Couldn't fetch: \(error)")
        }
        
        //return array of fetched data
        return locations
    }
    
    func fetchRoutes(location: String) -> [NSManagedObject]{
        //create array and set fetch request info
        var routes: [NSManagedObject] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Route")
        fetchRequest.predicate = NSPredicate(format: "location == %@", location)
        
        //fetch data
        do{
            routes = try context.fetch(fetchRequest)
        } catch let error as NSError{
            print("Couldn't fetch: \(error)")
        }
        
        //return array of fetched data
        return routes
    }
    
    func fetchProfile() -> [NSManagedObject]{
        //create array and set fetch request info
        var locations: [NSManagedObject] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProfileData")
        
        //fetch data
        do{
            locations = try context.fetch(fetchRequest)
        } catch let error as NSError{
            print("Couldn't fetch: \(error)")
        }
        
        return locations
    }
    
}
