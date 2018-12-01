//
//  CoreDataTask.swift
//  ImageProject
//
//  Created by rasl on 22.11.2018.
//  Copyright © 2018 rasl. All rights reserved.
//

import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let container = self.persistentContainer
        return container.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ImageProject")
        container.loadPersistentStores() { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    func addPhoto(_ image: UIImage) {
        let photo = Photo(context: managedObjectContext)
        photo.creationDate = Date() as Date
        if let image = image.jpegData(compressionQuality: 1.0) {
            photo.imageData = NSData(data: image) as Data
            
        }
        
        managedObjectContext.saveChanges()
    }
}

extension NSManagedObjectContext {
    func saveChanges() {
        if self.hasChanges {
            do {
                try save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}


