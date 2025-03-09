//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Александр Дудченко on 23.02.2025.
//

import UIKit

// Основной экран, где показывается список трекеров (каждый в своей ячейке)
final class TrackersViewController: UIViewController {
    // Словарь для хранения выполненных дат по каждому трекеру
    private var completedTrackers: [UUID: [Date]] = [:]
    
    // MARK: - Properties
    private var currentDate: Date = Date() {
        didSet {
            updateDateButtonTitle()
            updateTrackersForSelectedDate()
        }
    }
    
    // MARK: - UI Elements
    
    // Заголовок экрана "Трекеры"
    private let titleLabel: UILabel = {
        let label = UILabel()
        // Переводим в false, чтобы можно было настроить автолейаут
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Трекеры"
        // Крупный жирный шрифт (34, bold)
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    // Кнопка "+" вверху, открывает экран создания трекера
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        // Устанавливаем системную иконку "plus"
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        // Делаем иконку чёрного цвета
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Кнопка "Дата" вверху, показывает текущую дату
    private let dateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Дата", for: .normal)
        button.setTitleColor(.black, for: .normal)
        // Шрифт 17, regular
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        // Светло-серый фон
        button.backgroundColor = .systemGray5
        // Скругляем углы
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Поле поиска (UISearchBar)
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        // Плейсхолдер "Поиск"
        searchBar.placeholder = "Поиск"
        // Стиль минималистичный
        searchBar.searchBarStyle = .minimal
        // Убираем фон
        searchBar.backgroundImage = UIImage()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    // CollectionView, в котором отображаются секции и ячейки трекеров
    private let collectionView: UICollectionView = {
        // Создаем FlowLayout (вертикальный скролл)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16  // отступ между ячейками по вертикали
        // Размер заголовка для каждой секции (TrackerHeaderView)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 32)
        
        // Создаем UICollectionView с указанным layout
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        // Включаем автолейаут
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Mock Data
    
    // Пример массива категорий (section) и элементов (items)
    // Каждая секция имеет название (category) и массив Tracker
    private let trackers: [(category: String, items: [Tracker])] = [
        (
            "Домашний уют",
            [
                Tracker(id: UUID(), name: "Поливать растения", emoji: "❤️", color: .systemGreen, schedule: [1, 3, 5], completedDates: [])
            ]
        ),
        (
            "Радостные мелочи",
            [
                Tracker(id: UUID(), name: "Кошка заслонила камеру на созвоне", emoji: "😻", color: .systemOrange, schedule: [2, 4], completedDates: []),
                Tracker(id: UUID(), name: "Бабушка прислала открытку в WhatsApp", emoji: "🌺", color: .systemRed, schedule: [1, 6], completedDates: [])
            ]
        )
    ]
    
    private var filteredTrackers: [(category: String, items: [Tracker])] = []
    
    // MARK: - Lifecycle
    
    // Метод вызывается после загрузки контроллера
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Белый фон
        view.backgroundColor = .white
        // Скрываем навбар
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Настраиваем UI и CollectionView
        setupUI()
        setupCollectionView()
        updateTrackersForSelectedDate()
    }
    
    // MARK: - UI Setup
    
    // Добавляем элементы на экран и задаем им констрейнты
    private func setupUI() {
        // Добавляем titleLabel, plusButton, dateButton, searchBar, collectionView
        view.addSubview(titleLabel)
        view.addSubview(plusButton)
        view.addSubview(dateButton)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        // Добавляем таргеты на кнопки
        plusButton.addTarget(self, action: #selector(addTrackerTapped), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        
        // Ставим на кнопке "Дата" текущую дату (пример)
        updateDateButtonTitle()
        
        // Устанавливаем констрейнты
        setupConstraints()
    }
    
    // Расставляем констрейнты для добавленных сабвью
    private func setupConstraints() {
        // safeArea - верх/низ экрана с учётом выреза и т.п.
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // plusButton: 16pt отступ сверху и слева
            plusButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            plusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            plusButton.widthAnchor.constraint(equalToConstant: 42),
            plusButton.heightAnchor.constraint(equalToConstant: 42),
            
            // titleLabel располагается под плюс-кнопкой (отступ 1pt),
            // слева 16pt
            titleLabel.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            // Уступаем немного места перед кнопкой даты
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: dateButton.leadingAnchor, constant: -8),
            
            // dateButton центрируется по вертикали относительно plusButton
            dateButton.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            // прижат к правому краю экрана (отступ 16pt)
            dateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            // фиксированная ширина/высота
            dateButton.widthAnchor.constraint(equalToConstant: 77),
            dateButton.heightAnchor.constraint(equalToConstant: 34),
            
            // searchBar под заголовком (отступ 8pt),
            // слева/справа 16pt
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            // collectionView под searchBar (16pt отступ),
            // на всю ширину экрана, до самого низа
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Collection View Setup
    
    // Регистрируем ячейку и заголовок, назначаем dataSource, delegate
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Настройка отступов и расстояний между ячейками
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16) // Отступы по краям
            layout.minimumInteritemSpacing = 16  // Отступ между элементами в ряду
            layout.minimumLineSpacing = 16       // Отступ между рядами
        }
        
        // Регистрируем класс TrackerCell с reuseIdentifier
        collectionView.register(
            TrackerCell.self,
            forCellWithReuseIdentifier: TrackerCell.identifier
        )
        
        // Регистрируем заголовок (TrackerHeaderView) для секций
        collectionView.register(
            TrackerHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerHeaderView.identifier
        )
    }
    
    // MARK: - Actions
    
    // Метод, вызываемый при нажатии на "+"
    @objc private func addTrackerTapped() {
        // Создаем контроллер для создания трекера (пример)
        let createTrackerVC = CreateTrackerViewController()
        // Отображаем его в стиле PageSheet
        createTrackerVC.modalPresentationStyle = .pageSheet
        present(createTrackerVC, animated: true)
        print("Кнопка «+» нажата")
    }
    
    // Метод, вызываемый при нажатии на "Дата"
    @objc private func dateButtonTapped() {
        // Если контейнер уже существует, удаляем его
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

        // Размещаем контейнер так, чтобы он НЕ перекрывал "Трекеры", но перекрывал поиск
        // Привязываем верх контейнера чуть выше searchBar

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            // Смещаем вверх на 8pt относительно searchBar
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
    filteredTrackers = trackers.map { category in
        let filteredItems = category.items
        return (category.category, filteredItems)
    }.filter { !$0.items.isEmpty }
        collectionView.reloadData()
    }

    private func toggleCompletion(for tracker: Tracker, at indexPath: IndexPath) {
    let day = Calendar.current.startOfDay(for: currentDate)
    
    // Проверяем, есть ли записи в completedTrackers
    if completedTrackers[tracker.id] == nil {
        completedTrackers[tracker.id] = []
    }
    
    if let existingIndex = completedTrackers[tracker.id]?.firstIndex(where: { Calendar.current.isDate($0, inSameDayAs: day) }) {
        // Если дата уже есть, удаляем её (снимаем отметку)
        completedTrackers[tracker.id]?.remove(at: existingIndex)
    } else {
        // Иначе добавляем новую отметку
        completedTrackers[tracker.id]?.append(day)
    }
    
    // Обновляем конкретную ячейку в CollectionView
    collectionView.reloadItems(at: [indexPath])
}
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    
    // Возвращает количество секций (категорий)
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredTrackers.count
    }
    
    // Возвращаем количество элементов в конкретной секции
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return filteredTrackers[section].items.count
    }
    
    // Создаём/заполняем ячейку для indexPath
    func collectionView(_ collectionView: UICollectionView,
                    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: TrackerCell.identifier,
        for: indexPath
    ) as? TrackerCell else {
        return UICollectionViewCell()
    }

    let tracker = filteredTrackers[indexPath.section].items[indexPath.item]

    // Проверяем, является ли выбранная дата будущей
    let today = Calendar.current.startOfDay(for: Date())
    let isFutureDate = Calendar.current.compare(currentDate, to: today, toGranularity: .day) == .orderedDescending
    
    // Считаем, сколько раз трекер был выполнен (не только сегодня, а за всю историю)
    let completedDaysCount = completedTrackers[tracker.id]?.count ?? 0
    let isCompletedToday = completedTrackers[tracker.id]?.contains { Calendar.current.isDate($0, inSameDayAs: currentDate) } ?? false
    
    cell.configure(with: tracker, isCompleted: isCompletedToday, count: completedDaysCount)
    
    // Запрещаем отметку для будущей даты
    cell.completeButton.isEnabled = !isFutureDate
    
    cell.didTapComplete = { [weak self] in
        guard let self = self, !isFutureDate else { return }
        self.toggleCompletion(for: tracker, at: indexPath)
    }

    return cell
    }
    
    // Создаём/заполняем header (TrackerHeaderView) для секции
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
        
        // Управляй отступами вручную для каждого заголовка
        if categoryTitle == "Домашний уют" {
            header.configure(title: categoryTitle, leadingInset: 28, trailingInset: 198)
        } else if categoryTitle == "Радостные мелочи" {
            header.configure(title: categoryTitle, leadingInset: 28, trailingInset: 159)
        } else {
            header.configure(title: categoryTitle, leadingInset: 28, trailingInset: 198)
        }
        
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    // Указываем размер ячейки (167×148) — соответствует дизайну
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 167, height: 148)
    }
}
