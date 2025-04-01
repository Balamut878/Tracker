//
//  Store.swift
//  Tracker
//
//  Created by Александр Дудченко on 24.03.2025.
//

import Foundation
import CoreData

final class Store {
    static let shared = Store()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "TrackerDataModel")
        
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Error loading Persistent Stores: \(error)")
            }
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
