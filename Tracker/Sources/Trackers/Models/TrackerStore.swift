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
            completedDates: []
        )
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
        guard let schedule = schedule else { return nil }
        return schedule.map { String($0) }.joined(separator: ",")
    }
    
    private func convertStringToSchedule(_ string: String?) -> [Int]? {
        guard let string = string, !string.isEmpty else { return nil }
        return string.split(separator: ",").compactMap { Int($0) }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Данные в TrackerStore изменились")
    }
}
