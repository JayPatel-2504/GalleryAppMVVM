//
//  CoreDataManager.swift
//  GalleryAppMVVM
//
//  Created by Shiv's on 03/03/26.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GalleryModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData failed \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveImages(_ images: [ImageModel]) {
        
        deleteAllImages()
        
        for image in images {
            let entity = ImageEntity(context: context)
            entity.id = image.id
            entity.downloadURL = image.downloadUrl
        }
     
        saveContext()
    }
    
    func fetchImages() -> [ImageEntity] {
        
        let request: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print("Fatched fail")
            return []
        }
        
    }
    
    func deleteAllImages() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Delete failed:", error)
        }
        
    }
    
    func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
    
}
