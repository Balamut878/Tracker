//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Александр Дудченко on 24.03.2025.
//

import Foundation
import CoreData

final class TrackerRecordStore: NSObject {
    private let store = Store.shared
    
    // MARK: - Создание записи (отметки выполнения трекера)
    func createRecord(trackerID: UUID, date: Date) {
        let context = store.persistentContainer.viewContext
        
        let trackerRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        trackerRequest.predicate = NSPredicate(format: "id == %@", trackerID as CVarArg)
        
        do {
            if let trackerCD = try context.fetch(trackerRequest).first {
                let record = TrackerRecordCoreData(context: context)
                record.date = date
                record.tracker = trackerCD
                
                store.saveContext()
            } else {
                print("Tracker не найден для trackerID \(trackerID)")
            }
        } catch {
            print("Ошибка при поиске трекера: \(error)")
        }
    }
    
    // MARK: - Удаление записи
    func deleteRecord(trackerID: UUID, date: Date) {
        let context = store.persistentContainer.viewContext
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "tracker.id == %@", trackerID as CVarArg),
            NSPredicate(format: "date == %@", date as CVarArg)
        ])
        
        do {
            if let recordToDelete = try context.fetch(request).first {
                context.delete(recordToDelete)
                store.saveContext()
            }
        } catch {
            print("Ошибка при удалении записи: \(error)")
        }
    }
    
    // MARK: - Получение всех записей
    func fetchAllRecords() -> [TrackerRecordCoreData] {
        let context = store.persistentContainer.viewContext
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Ошибка при получении записей: \(error)")
            return []
        }
    }
    
    // MARK: - Преобразование объекта Core Data в структуру TrackerRecord
    func makeRecord(from cdObject: TrackerRecordCoreData) -> TrackerRecord? {
        guard let date = cdObject.date,
              let trackerCD = cdObject.tracker,
              let trackerID = trackerCD.id else {
            return nil
        }
        
        return TrackerRecord(trackerID: trackerID, date: date)
    }
}
