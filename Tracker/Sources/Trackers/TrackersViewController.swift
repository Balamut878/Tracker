//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Александр Дудченко on 23.02.2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    private var completedTrackers: Set<TrackerRecord> = []
    
    // MARK: - Properties
    private var currentDate: Date = Date() {
        didSet {
            updateDateButtonTitle()
            updateTrackersForSelectedDate()
        }
    }
    
    // MARK: - Данные из Core Data
    private var trackers: [TrackerCategory] = []
    private let trackerStore = TrackerStore()
    private let categoryStore = TrackerCategoryStore()
    private let recordStore = TrackerRecordStore()
    
    private var filteredTrackers: [(category: String, items: [Tracker])] = []
    
    // MARK: - UI Elements
    private let emptyPlaceholderView: UIView = {
        let container = UIView()
        container.isHidden = true
        
        let imageView = UIImageView(image: UIImage(named: "iconPlaceholderStar"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        container.addSubview(imageView)
        
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "Black[day]")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])
        
        return container
    }()
    
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.textColor = UIColor(named: "Gray")
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let dateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor(named: "Black[day]"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.backgroundColor = UIColor(named: "LightGray")
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 9
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 32)
        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
        layout.estimatedItemSize = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInsetAdjustmentBehavior = .automatic
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "White[day]")
        
        setupUI()
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        setupNavigationBar()
        setupCollectionView()
        loadData()
        updateDateButtonTitle()
    }
    
    private func setupUI() {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Трекеры"
            label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
            label.textColor = UIColor(named: "Black[day]")
            label.textAlignment = .left
            return label
        }()
        view.addSubview(titleLabel)
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(emptyPlaceholderView)
        emptyPlaceholderView.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyPlaceholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyPlaceholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Collection View Setup
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(
            TrackerCell.self,
            forCellWithReuseIdentifier: TrackerCell.identifier
        )
        collectionView.register(
            TrackerHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerHeaderView.identifier
        )
    }
    
    // MARK: - Data Loading
    
    private func loadData() {
        let categoriesCD = categoryStore.fetchAllCategories()
        
        if categoriesCD.isEmpty {
            let defaultCategoryCD = categoryStore.createCategory(title: "По умолчанию")
            if let defaultCategory = categoryStore.makeCategory(from: defaultCategoryCD) {
                trackers = [defaultCategory]
            }
        } else {
            trackers = categoriesCD.compactMap { categoryStore.makeCategory(from: $0) }
        }
        
        updateTrackersForSelectedDate()
        
        let allRecords = recordStore.fetchAllRecords()
        completedTrackers = Set(allRecords.compactMap { recordStore.makeRecord(from: $0) })
    }
    
    // MARK: - Actions
    
    @objc private func addTrackerTapped() {
        let createTrackerVC = CreateTrackerViewController()
        let navController = UINavigationController(rootViewController: createTrackerVC)
        navController.modalPresentationStyle = .pageSheet
        
        createTrackerVC.onCreateTracker = { [weak self] newTracker in
            guard let self = self else { return }
            
            let categoriesCD = self.categoryStore.fetchAllCategories()
            var defaultCategoryCD: TrackerCategoryCoreData?
            if let category = categoriesCD.first(where: { $0.title == "По умолчанию" }) {
                defaultCategoryCD = category
            } else {
                defaultCategoryCD = self.categoryStore.createCategory(title: "По умолчанию")
            }
            
            if let defaultCategoryCD = defaultCategoryCD {
                self.trackerStore.createTracker(newTracker, category: defaultCategoryCD)
                self.loadData()
            }
        }
        
        present(navController, animated: true)
        print("Кнопка «+» нажата")
    }
    
    @objc private func dateButtonTapped() {
        if let existingContainer = view.subviews.first(where: { $0.tag == 999 }) {
            existingContainer.removeFromSuperview()
            return
        }
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.date = currentDate
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 13
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.1
        container.layer.shadowOffset = CGSize(width: 0, height: 10)
        container.layer.shadowRadius = 60
        container.tag = 999
        
        view.addSubview(container)
        container.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            container.topAnchor.constraint(equalTo: searchBar.topAnchor, constant: -8),
            container.heightAnchor.constraint(equalToConstant: 325),
            
            datePicker.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        view.bringSubviewToFront(container)
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        dismiss(animated: true)
    }
    
    private func updateDateButtonTitle() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        let dateString = formatter.string(from: currentDate)
        dateButton.setTitle(dateString, for: .normal)
    }
    
    private func updateTrackersForSelectedDate() {
        let calendar = Calendar.current
        let systemWeekday = calendar.component(.weekday, from: currentDate)
        let myWeekday = (systemWeekday + 5) % 7
        
        filteredTrackers = trackers.map { category in
            let filteredItems = category.trackers.filter { tracker in
                switch tracker.type {
                case .habit:
                    return tracker.schedule?.contains(myWeekday) ?? false
                case .irregularEvent:
                    return calendar.isDate(tracker.createdDate, inSameDayAs: currentDate)
                }
            }
            return (category.title, filteredItems)
        }
        .filter { !$0.items.isEmpty }
        
        collectionView.reloadData()
        emptyPlaceholderView.isHidden = !filteredTrackers.isEmpty
    }
    
    private func toggleCompletion(for tracker: Tracker, at indexPath: IndexPath) {
        let day = Calendar.current.startOfDay(for: currentDate)
        let record = TrackerRecord(trackerID: tracker.id, date: day)
        
        if completedTrackers.contains(record) {
            completedTrackers.remove(record)
            recordStore.deleteRecord(trackerID: tracker.id, date: day)
        } else {
            completedTrackers.insert(record)
            recordStore.createRecord(trackerID: tracker.id, date: day)
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - Navigation Bar Setup
extension TrackersViewController {
    private func setupNavigationBar() {
        title = ""
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "iconPlus"),
            style: .plain,
            target: self,
            action: #selector(addTrackerTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "Black[day]")
        
        let dateWrapperView = UIView(frame: CGRect(x: 0, y: 0, width: 77, height: 34))
        dateWrapperView.addSubview(dateButton)
        
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateButton.topAnchor.constraint(equalTo: dateWrapperView.topAnchor),
            dateButton.bottomAnchor.constraint(equalTo: dateWrapperView.bottomAnchor),
            dateButton.leadingAnchor.constraint(equalTo: dateWrapperView.leadingAnchor),
            dateButton.trailingAnchor.constraint(equalTo: dateWrapperView.trailingAnchor)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: dateWrapperView)
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredTrackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredTrackers[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.identifier,
            for: indexPath
        ) as? TrackerCell else {
            assertionFailure("Unable to dequeue TrackerCell")
            return UICollectionViewCell()
        }
        
        let tracker = filteredTrackers[indexPath.section].items[indexPath.item]
        
        let today = Calendar.current.startOfDay(for: Date())
        let isFutureDate = Calendar.current.compare(currentDate, to: today, toGranularity: .day) == .orderedDescending
        
        let completedDaysCount = completedTrackers.filter { $0.trackerID == tracker.id }.count
        
        let isCompletedToday = completedTrackers.contains {
            $0.trackerID == tracker.id &&
            Calendar.current.isDate($0.date, inSameDayAs: currentDate)
        }
        
        cell.configure(with: tracker, isCompleted: isCompletedToday, count: completedDaysCount)
        cell.completeButton.isEnabled = !isFutureDate
        
        cell.didTapComplete = { [weak self] in
            guard let self = self, !isFutureDate else { return }
            self.toggleCompletion(for: tracker, at: indexPath)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerHeaderView.identifier,
            for: indexPath
        ) as? TrackerHeaderView else {
            return UICollectionReusableView()
        }
        
        let categoryTitle = filteredTrackers[indexPath.section].category
        header.configure(title: categoryTitle, leadingInset: 28, trailingInset: 16)
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: 167, height: 148)
        }
        
        let columns: CGFloat = 2
        let totalInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let totalSpacing = flowLayout.minimumInteritemSpacing * (columns - 1)
        let availableWidth = collectionView.bounds.width - totalInsets - totalSpacing
        
        let cellWidth = floor(availableWidth / columns)
        let cellHeight: CGFloat = 148
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
