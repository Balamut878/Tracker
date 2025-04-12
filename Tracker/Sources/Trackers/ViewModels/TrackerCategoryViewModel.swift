//
//  TrackerCategoryViewModel.swift
//  Tracker
//
//  Created by Александр Дудченко on 07.04.2025.
//

import Foundation

final class TrackerCategoryViewModel {
    
    // MARK: - Public Properties
    var onCategoriesChanged: (([TrackerCategory]) -> Void)?
    
    // MARK: - Internal Properties
    let trackerCategoryStore: TrackerCategoryStore
    
    // MARK: - Init
    init(trackerCategoryStore: TrackerCategoryStore = TrackerCategoryStore()) {
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerCategoryStore.delegate = self
        fetchCategories()
    }
    
    // MARK: - Private Methods
    private func fetchCategories() {
        let categories = trackerCategoryStore.fetchCategories()
        onCategoriesChanged?(categories)
    }
    
    // MARK: - Public Methods
    func reloadCategories() {
        fetchCategories()
    }
}

// MARK: - TrackerCategoryStoreDelegate
extension TrackerCategoryViewModel: TrackerCategoryStoreDelegate {
    func didUpdateCategories(_ categories: [TrackerCategory]) {
        onCategoriesChanged?(categories)
    }
}
