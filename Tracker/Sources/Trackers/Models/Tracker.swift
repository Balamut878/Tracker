//
//  Tracker.swift
//  Tracker
//
//  Created by Александр Дудченко on 02.03.2025.
//

import UIKit

struct Tracker {
    enum TrackerType {
        case habit
        case irregularEvent
    }
    
    let id: UUID
    let name: String
    let emoji: String
    let color: UIColor
    let schedule: [Int]?
    let type: TrackerType
    let createdDate: Date
    let completedDates: [Date]
    let categoryTitle: String
    
    init(
        id: UUID,
        name: String,
        emoji: String,
        color: UIColor,
        schedule: [Int]?,
        type: TrackerType,
        createdDate: Date,
        completedDates: [Date],
        categoryTitle: String
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.color = color
        self.schedule = schedule
        self.type = type
        self.createdDate = createdDate
        self.completedDates = completedDates
        self.categoryTitle = categoryTitle
    }
}
