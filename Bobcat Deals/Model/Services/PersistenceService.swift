//
//  PersistenceService.swift
//  Bobcat Deals
//
//  Created by Enrique Florencio on 12/29/20.


import Foundation
import CoreData

public class PersistenceService {
    
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Bobcat_Deals")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext

    // MARK: - Core Data Saving support

    public func save() -> Bool {
        var didSave = false
        if context.hasChanges {
            do {
                try context.save()
                didSave = true
                print("saved successfully")
            } catch {

                let nserror = error as NSError
                print(nserror)
                didSave = false
                //fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        return didSave
    }
    
    public func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            guard let fetchedObjects = try context.fetch(fetchRequest) as? [T] else {
                return [T]()
            }
            return fetchedObjects
            
        } catch {
            print(error)
            return [T]()
        }
        
        
    }
    
    public func fetchBusiness(_ name: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bookmark")
        fetchRequest.predicate = NSPredicate(format: "businessName = %@", name)
        
        do {
            guard let fetchedObjects = try context.fetch(fetchRequest) as? [Bookmark] else {
                return false
            }
            
//            print(fetchedObjects.first?.businessName)
            
            if(fetchedObjects.first == nil) {
                return false
            }
            
            return true
        } catch {
            print(error)
            return false
        }
        
    }
    
    public func deleteBookmark(_ name: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bookmark")
        fetchRequest.predicate = NSPredicate(format: "businessName = %@", name)
        
        do {
            guard let fetchedObjects = try context.fetch(fetchRequest) as? [Bookmark] else {
                return false
            }
            
            context.delete(fetchedObjects.first!)
            save()
            
            return true
        } catch {
            print(error)
            return false
        }
    
    }
}
