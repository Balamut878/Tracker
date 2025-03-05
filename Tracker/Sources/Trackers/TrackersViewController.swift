//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Александр Дудченко on 23.02.2025.
//

import UIKit

// Основной экран, где показывается список трекеров (каждый в своей ячейке)
final class TrackersViewController: UIViewController {

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
                Tracker(id: UUID(), name: "Поливать растения", emoji: "❤️", color: .systemGreen, schedule: [1, 3, 5])
            ]
        ),
        (
            "Радостные мелочи",
            [
                Tracker(id: UUID(), name: "Кошка заслонила камеру на созвоне", emoji: "😻", color: .systemOrange, schedule: [2, 4]),
                Tracker(id: UUID(), name: "Бабушка прислала открытку в WhatsApp", emoji: "🌺", color: .systemRed, schedule: [1, 6])
            ]
        )
    ]
    
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
        dateButton.setTitle(currentDateString(), for: .normal)
        
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
        print("Кнопка даты нажата")
    }
    
    // Возвращает текущую дату строкой (формат "dd.MM.yy")
    private func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter.string(from: Date())
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {

    // Возвращает количество секций (категорий)
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return trackers.count
    }
    
    // Возвращаем количество элементов в конкретной секции
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return trackers[section].items.count
    }
    
    // Создаём/заполняем ячейку для indexPath
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Достаём ячейку по нашему идентификатору
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.identifier,
            for: indexPath
        ) as? TrackerCell else {
            // Если почему-то не получилось, возвращаем пустую дефолтную
            return UICollectionViewCell()
        }
        
        // Берём трекер из массива
        let tracker = trackers[indexPath.section].items[indexPath.item]
        // Настраиваем ячейку: isCompleted = false, count = 0 (временно)
        cell.configure(with: tracker, isCompleted: false, count: 0)
        
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

        let categoryTitle = trackers[indexPath.section].category

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
