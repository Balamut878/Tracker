//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Александр Дудченко on 23.02.2025.
//

import UIKit

class StatisticsViewController: UIViewController {
    private var statistics: [StatisticItem] = []
    private let tableView = UITableView()
    private let recordStore = TrackerRecordStore()
    private let trackerStore = TrackerStore()
    private let categoryStore = TrackerCategoryStore()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Статистика"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor(named: "Black[day]")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "White[day]")
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didUpdateRecords),
            name: .trackerRecordDidUpdate,
            object: nil
        )
        
        setupTableView()
        calculateStatistics()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "White[day]")
        tableView.separatorStyle = .none
        tableView.register(StatisticCell.self, forCellReuseIdentifier: "StatisticCell")
        tableView.rowHeight = 98
        tableView.estimatedRowHeight = 98
        tableView.dataSource = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func showPlaceholder() {
        let placeholderContainer = UIView()
        placeholderContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderContainer)
        
        let imageView = UIImageView(image: UIImage(named: "statisticsPlaceholder"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        placeholderContainer.addSubview(imageView)
        
        let textLabel = UILabel()
        textLabel.text = "Анализировать пока нечего"
        textLabel.textColor = UIColor(named: "Black[day]")
        textLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderContainer.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            placeholderContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: placeholderContainer.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: placeholderContainer.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            textLabel.centerXAnchor.constraint(equalTo: placeholderContainer.centerXAnchor),
            textLabel.bottomAnchor.constraint(equalTo: placeholderContainer.bottomAnchor)
        ])
    }
    
    private func updateUI() {
        let hasStats = statistics.contains { $0.value > 0 }
        tableView.isHidden = !hasStats
        tableView.reloadData()
        if !hasStats {
            tableView.isHidden = true
            showPlaceholder()
        } else {
            removePlaceholderIfNeeded()
        }
    }
    
    private func removePlaceholderIfNeeded() {
        view.subviews
            .filter { $0.subviews.contains(where: { $0 is UIImageView }) }
            .forEach { $0.removeFromSuperview() }
    }
    
    private func calculateStatistics() {
        let allTrackers = trackerStore.fetchAllTrackers()
        let allRecords = recordStore.fetchAllRecords()
        
        guard !allTrackers.isEmpty, !allRecords.isEmpty else {
            statistics = []
            updateUI()
            return
        }
        
        let calendar = Calendar.current
        let sortedRecords = allRecords.sorted {
            guard let date0 = $0.date, let date1 = $1.date else { return false }
            return date0 < date1
        }
        
        var longestStreak = 0
        var currentStreak = 0
        var previousDate: Date?
        
        for record in sortedRecords {
            guard let date = record.date else { continue }
            let currentDate = calendar.startOfDay(for: date)
            if let prev = previousDate, let nextDay = calendar.date(byAdding: .day, value: 1, to: prev), nextDay.compare(currentDate) == .orderedSame {
                currentStreak += 1
            } else {
                currentStreak = 1
            }
            longestStreak = max(longestStreak, currentStreak)
            previousDate = currentDate
        }
        
        let completedTrackersCount = allRecords.count
        
        let uniqueDays = Set(allRecords.compactMap { $0.date.map { calendar.startOfDay(for: $0) } })
        let average = Double(completedTrackersCount) / Double(uniqueDays.count)
        let averageValue = Int(round(average))
        
        var perfectDays = 0
        let groupedByDate = Dictionary(grouping: allRecords, by: { record in
            guard let date = record.date else { return Date.distantPast }
            return calendar.startOfDay(for: date)
        })
        
        for (date, recordsOnDate) in groupedByDate {
            let scheduledForDate = allTrackers.filter { tracker in
                guard let schedule = tracker.schedule else { return false }
                let weekday = (calendar.component(.weekday, from: date) + 5) % 7
                return schedule.contains(where: { $0 == Character(String(weekday)) })
            }
            if !scheduledForDate.isEmpty && scheduledForDate.allSatisfy({ tracker in
                recordsOnDate.contains(where: { $0.tracker?.id == tracker.id })
            }) {
                perfectDays += 1
            }
        }
        
        statistics = [
            StatisticItem(value: longestStreak, title: "Самый длинный период"),
            StatisticItem(value: completedTrackersCount, title: "Трекеров завершено"),
            StatisticItem(value: averageValue, title: "Среднее значение"),
            StatisticItem(value: perfectDays, title: "Идеальные дни")
        ]
        updateUI()
    }
    
    @objc private func didUpdateRecords() {
        calculateStatistics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculateStatistics()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statistics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticCell", for: indexPath) as? StatisticCell else {
            return UITableViewCell()
        }
        let item = statistics[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

extension Notification.Name {
    static let trackerRecordDidUpdate = Notification.Name("trackerRecordDidUpdate")
}
