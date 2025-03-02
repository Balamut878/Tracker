//
//  Tracker.swift
//  Tracker
//
//  Created by Александр Дудченко on 02.03.2025.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let emoji: String
    let color: UIColor
    let schedule: [Int] // Дни недели (например, [1,3,5] — Понедельник, Среда, Пятница)
}
