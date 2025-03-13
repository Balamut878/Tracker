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
    var completedDates: [Date]
}
