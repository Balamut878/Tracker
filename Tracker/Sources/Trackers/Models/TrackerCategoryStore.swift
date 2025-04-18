//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Александр Дудченко on 24.03.2025.
//

import Foundation
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdateCategories(_ categories: [TrackerCategory])
}

final class TrackerCategoryStore: NSObject {
    private let store = Store.shared
    weak var delegate: TrackerCategoryStoreDelegate?
    
    // MARK: - Создание новой категории
    func createCategory(title: String) -> TrackerCategoryCoreData {
        let context = store.persistentContainer.viewContext
        let category = TrackerCategoryCoreData(context: context)
        category.title = title
        store.saveContext()
        delegate?.didUpdateCategories(fetchAllCategories().compactMap { makeCategory(from: $0) })
        return category
    }
    
    // MARK: - Получение всех категорий
    func fetchAllCategories() -> [TrackerCategoryCoreData] {
        let context = store.persistentContainer.viewContext
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Ошибка получения категорий: \(error)")
            return []
        }
    }
    
    // MARK: - Преобразование объекта Core Data в модель
    func makeCategory(from cdObject: TrackerCategoryCoreData) -> TrackerCategory? {
        guard let title = cdObject.title else {
            return nil
        }
        let trackerCDArray = (cdObject.trackers?.allObjects as? [TrackerCoreData]) ?? []
        let trackerStore = TrackerStore()
        let trackers = trackerCDArray.compactMap { trackerStore.makeTracker(from: $0) }
        
        return TrackerCategory(title: title, trackers: trackers)
    }
    
    func fetchCategories() -> [TrackerCategory] {
        return fetchAllCategories().compactMap { makeCategory(from: $0) }
    }
}
