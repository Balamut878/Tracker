//
//  TrackerStore.swift
//  Tracker
//
//  Created by Александр Дудченко on 24.03.2025.
//

import Foundation
import CoreData
import UIKit

final class TrackerStore: NSObject {
    private let store = Store.shared
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    
    override init() {
        super.init()
        let context = store.persistentContainer.viewContext
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Ошибка получения трекеров: \(error)")
        }
    }
    
    // MARK: - Создание трекера
    func createTracker(_ tracker: Tracker, category: TrackerCategoryCoreData) {
        let context = store.persistentContainer.viewContext
        let trackerCD = TrackerCoreData(context: context)
        
        trackerCD.id = tracker.id
        trackerCD.name = tracker.name
        trackerCD.emoji = tracker.emoji
        trackerCD.color = convertColorToString(tracker.color)
        trackerCD.schedule = convertScheduleToString(tracker.schedule)
        trackerCD.type = (tracker.type == .habit) ? "habit" : "irregular"
        trackerCD.createdDate = tracker.createdDate
        trackerCD.isPinned = false
        
        trackerCD.category = category
        
        store.saveContext()
    }
    
    // MARK: - Получение трекеров
    func fetchAllTrackers() -> [TrackerCoreData] {
        let context = store.persistentContainer.viewContext
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Ошибка получения трекеров: \(error)")
            return []
        }
    }
    
    // MARK: - Преобразование из Core Data в модель
    func makeTracker(from cdObject: TrackerCoreData) -> Tracker? {
        guard let id = cdObject.id,
              let name = cdObject.name,
              let emoji = cdObject.emoji,
              let createdDate = cdObject.createdDate,
              let typeString = cdObject.type
        else {
            return nil
        }
        
        let color = convertStringToColor(cdObject.color)
        let schedule = convertStringToSchedule(cdObject.schedule)
        let type: Tracker.TrackerType = (typeString == "habit") ? .habit : .irregularEvent
        
        return Tracker(
            id: id,
            name: name,
            emoji: emoji,
            color: color,
            schedule: schedule,
            type: type,
            createdDate: createdDate,
            completedDates: cdObject.records?.compactMap {
                ($0 as? TrackerRecordCoreData)?.date
            } ?? [],
            categoryTitle: cdObject.category?.title ?? "По умолчанию",
            isPinned: cdObject.isPinned
            
        )
    }
    
    // MARK: - Обновление трекера
    func updateTracker(_ updatedTracker: Tracker) {
        let context = store.persistentContainer.viewContext
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", updatedTracker.id as CVarArg)
        
        do {
            if let trackerCD = try context.fetch(request).first {
                trackerCD.name = updatedTracker.name
                trackerCD.emoji = updatedTracker.emoji
                trackerCD.color = convertColorToString(updatedTracker.color)
                trackerCD.schedule = convertScheduleToString(updatedTracker.schedule)
                trackerCD.type = (updatedTracker.type == .habit) ? "habit" : "irregular"
                trackerCD.createdDate = updatedTracker.createdDate
                trackerCD.isPinned = updatedTracker.isPinned
                store.saveContext()
            }
        } catch {
            print("Ошибка при обновлении трекера: \(error)")
        }
    }
    
    // MARK: - Удаление трекера
    func deleteTracker(_ tracker: Tracker) {
        let context = store.persistentContainer.viewContext
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        do {
            if let trackerCD = try context.fetch(request).first {
                context.delete(trackerCD)
                store.saveContext()
            }
        } catch {
            print("Ошибка при удалении трекера: \(error)")
        }
    }
    
    // MARK: - Переключение закрепления трекера
    func togglePin(for tracker: Tracker) {
        let context = store.persistentContainer.viewContext
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        do {
            if let trackerCD = try context.fetch(request).first {
                trackerCD.isPinned = !(trackerCD.isPinned)
                store.saveContext()
                try? fetchedResultsController?.performFetch()
                NotificationCenter.default.post(name: NSNotification.Name("TrackerStoreDidUpdate"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("ReloadTrackersAfterPin"), object: nil)
            }
        } catch {
            print("Ошибка при переключении закрепления трекера: \(error)")
        }
    }
    
    // MARK: - Вспомогательные методы конвертации
    private func convertColorToString(_ color: UIColor) -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
    
    private func convertStringToColor(_ string: String?) -> UIColor {
        guard let string = string,
              string.hasPrefix("#"),
              string.count == 7
        else {
            return .white
        }
        let hex = String(string.dropFirst())
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        
        let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgbValue & 0x0000FF) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
    private func convertScheduleToString(_ schedule: [Int]?) -> String? {
        guard let schedule = schedule, !schedule.isEmpty else { return nil }
        return schedule.map(String.init).joined(separator: ",")
    }
    
    private func convertStringToSchedule(_ string: String?) -> [Int]? {
        guard let string = string, !string.isEmpty else { return nil }
        return string.split(separator: ",").compactMap { Int($0) }
    }
    
    @objc private func loadData() {
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Данные в TrackerStore изменились")
    }
}
