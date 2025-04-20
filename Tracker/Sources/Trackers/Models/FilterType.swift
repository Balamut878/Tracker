//
//  FilterType.swift
//  Tracker
//
//  Created by Александр Дудченко on 20.04.2025.
//

import Foundation

enum FilterType: String, CaseIterable {
    case all = "Все трекеры"
    case today = "Трекеры на сегодня"
    case completed = "Завершённые"
    case uncompleted = "Незавершённые"
}
