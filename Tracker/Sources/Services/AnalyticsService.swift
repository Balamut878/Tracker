//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Александр Дудченко on 21.04.2025.
//

import Foundation
import AppMetricaCore

final class AnalyticsService {
    static let shared = AnalyticsService()

    private init() {}

    func report(event: String, screen: String, item: String? = nil) {
        var parameters: [AnyHashable: Any] = [
            "event": event,
            "screen": screen
        ]

        if let item = item {
            parameters["item"] = item
        }

        print("🔵 Sending event: \(event), screen: \(screen), item: \(item ?? "nil")")
        print("🔵 Full parameters:", parameters)
        AppMetrica.reportEvent(name: event, parameters: parameters)
    }
}
