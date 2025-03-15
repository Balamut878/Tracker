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
    
    // MARK: - UI Elements
    private let emptyPlaceholderView: UIView = {
        let container = UIView()
        container.isHidden = true
        let imageView = UIImageView(image: UIImage(named: "iconPlaceholderStar"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Дата", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 32)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Mock Data
    private var trackers: [TrackerCategory] = [
        TrackerCategory(title: "По умолчанию", trackers: [])
    ]
    
    private var filteredTrackers: [(category: String, items: [Tracker])] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupUI()
        setupCollectionView()
        updateTrackersForSelectedDate()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(plusButton)
        view.addSubview(dateButton)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(emptyPlaceholderView)
        emptyPlaceholderView.translatesAutoresizingMaskIntoConstraints = false
        plusButton.addTarget(self, action: #selector(addTrackerTapped), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        updateDateButtonTitle()
        setupConstraints()
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            plusButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            plusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            plusButton.widthAnchor.constraint(equalToConstant: 42),
            plusButton.heightAnchor.constraint(equalToConstant: 42),
            titleLabel.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: dateButton.leadingAnchor, constant: -8),
            dateButton.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            dateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dateButton.widthAnchor.constraint(equalToConstant: 77),
            dateButton.heightAnchor.constraint(equalToConstant: 34),
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
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
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            layout.minimumInteritemSpacing = 16
            layout.minimumLineSpacing = 16
        }
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        collectionView.register(TrackerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerHeaderView.identifier)
    }
    
    // MARK: - Actions
    @objc private func addTrackerTapped() {
        // ...
        let createTrackerVC = CreateTrackerViewController()
        createTrackerVC.modalPresentationStyle = .pageSheet
        
        createTrackerVC.onCreateTracker = { [weak self] newTracker in
            guard let self = self else { return }
            let oldCategory = self.trackers[0]
            var newTrackersArray = oldCategory.trackers
            newTrackersArray.append(newTracker)
            let updatedCategory = TrackerCategory(
                title: oldCategory.title,
                trackers: newTrackersArray
            )
            
            var updatedCategories = self.trackers
            updatedCategories[0] = updatedCategory
            self.trackers = updatedCategories
            self.updateTrackersForSelectedDate()
        }
        
        present(createTrackerVC, animated: true)
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
        dateButton.setTitle(formatter.string(from: currentDate), for: .normal)
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
                    return Calendar.current.isDate(tracker.createdDate, inSameDayAs: currentDate)
                }
            }
            return (category.title, filteredItems)
        }.filter { !$0.items.isEmpty }
        collectionView.reloadData()
        emptyPlaceholderView.isHidden = !filteredTrackers.isEmpty
    }
    
    private func toggleCompletion(for tracker: Tracker, at indexPath: IndexPath) {
        let day = Calendar.current.startOfDay(for: currentDate)
        let record = TrackerRecord(trackerID: tracker.id, date: day)
        if completedTrackers.contains(record) {
            completedTrackers.remove(record)
        } else {
            completedTrackers.insert(record)
        }
        collectionView.reloadItems(at: [indexPath])
    }
}

// Stub for CreateIrregularEventViewController
final class CreateIrregularEventViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        let tracker = filteredTrackers[indexPath.section].items[indexPath.item]
        let today = Calendar.current.startOfDay(for: Date())
        let isFutureDate = Calendar.current.compare(currentDate, to: today, toGranularity: .day) == .orderedDescending
        let completedDaysCount = completedTrackers.filter { $0.trackerID == tracker.id }.count
        let isCompletedToday = completedTrackers.contains {
            $0.trackerID == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: currentDate)
        }
        cell.configure(with: tracker, isCompleted: isCompletedToday, count: completedDaysCount)
        cell.completeButton.isEnabled = !isFutureDate
        cell.didTapComplete = { [weak self] in
            guard let self = self, !isFutureDate else { return }
            self.toggleCompletion(for: tracker, at: indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerHeaderView.identifier, for: indexPath) as? TrackerHeaderView else {
            return UICollectionReusableView()
        }
        let categoryTitle = filteredTrackers[indexPath.section].category
        header.configure(title: categoryTitle, leadingInset: 28, trailingInset: 16)
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 167, height: 148)
    }
}
