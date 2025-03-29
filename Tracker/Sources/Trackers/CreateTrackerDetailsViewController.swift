//
//  CreateTrackerDetailsViewController.swift
//  Tracker
//
//  Created by Александр Дудченко on 27.02.2025.
//

import UIKit

final class CreateTrackerDetailsViewController: UIViewController {
    
    private let trackerType: Tracker.TrackerType
    var onCreateTracker: ((Tracker) -> Void)?
    
    private var options: [String] = []
    private var selectedValues: [String?] = []
    private var selectedDaysIndices: [Int] = []
    
    private let emojiList = ["😊", "😻", "🌺", "🐶", "❤️", "😱",
                             "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                             "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    private var selectedEmojiIndex: IndexPath?
    private var selectedColorIndex: IndexPath?
    
    private let colorList: [UIColor] = (1...18).compactMap { UIColor(named: "Color selection \($0)") }
    
    // MARK: - UI Элементы
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let tableViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let emojiTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Emoji"
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emojiContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let colorTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Цвет"
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let colorContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - UIScrollView и contentView
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Кнопки "Отменить" и "Создать"
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let redColor = UIColor(named: "Red")!
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(redColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.borderColor = redColor.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor(named: "White[day]")?.withAlphaComponent(1.0), for: .normal)
        button.backgroundColor = UIColor(named: "Gray")
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Переменная для хранения констрейнта высоты tableViewContainer
    private var tableViewContainerHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Инициализатор
    init(trackerType: Tracker.TrackerType) {
        self.trackerType = trackerType
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if trackerType == .habit {
            titleLabel.text = "Новая привычка"
            options = ["Категория", "Расписание"]
            selectedValues = [nil, nil]
        } else {
            titleLabel.text = "Новое нерегулярное событие"
            options = ["Категория"]
            selectedValues = [nil]
        }
        
        setupUI()
        setupTableView()
        setupEmojiCollectionView()
        setupColorCollectionView()
        
        tableViewContainerHeightConstraint.constant = trackerType == .habit ? 150 : 75
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        updateCreateButtonState()
    }
    
    // MARK: - Настройка UI
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(tableViewContainer)
        tableViewContainer.addSubview(tableView)
        contentView.addSubview(emojiTitleLabel)
        contentView.addSubview(emojiContainerView)
        emojiContainerView.addSubview(emojiCollectionView)
        contentView.addSubview(colorTitleLabel)
        contentView.addSubview(colorContainerView)
        colorContainerView.addSubview(colorCollectionView)
        contentView.addSubview(cancelButton)
        contentView.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            tableViewContainer.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            tableViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableViewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            emojiTitleLabel.topAnchor.constraint(equalTo: tableViewContainer.bottomAnchor, constant: 16),
            emojiTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            
            emojiContainerView.topAnchor.constraint(equalTo: emojiTitleLabel.bottomAnchor, constant: 8),
            emojiContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emojiContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            emojiContainerView.heightAnchor.constraint(equalToConstant: 204),
            
            colorTitleLabel.topAnchor.constraint(equalTo: emojiContainerView.bottomAnchor, constant: 16),
            colorTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            
            colorContainerView.topAnchor.constraint(equalTo: colorTitleLabel.bottomAnchor, constant: 8),
            colorContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            colorContainerView.heightAnchor.constraint(equalToConstant: 204),
            
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cancelButton.topAnchor.constraint(equalTo: colorContainerView.bottomAnchor, constant: 16),
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            createButton.topAnchor.constraint(equalTo: colorContainerView.bottomAnchor, constant: 16),
            createButton.widthAnchor.constraint(equalToConstant: 166),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        tableViewContainerHeightConstraint = tableViewContainer.heightAnchor.constraint(equalToConstant: 150)
        tableViewContainerHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor),
            
            emojiCollectionView.topAnchor.constraint(equalTo: emojiContainerView.topAnchor),
            emojiCollectionView.leadingAnchor.constraint(equalTo: emojiContainerView.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: emojiContainerView.trailingAnchor),
            emojiCollectionView.bottomAnchor.constraint(equalTo: emojiContainerView.bottomAnchor),
            
            colorCollectionView.topAnchor.constraint(equalTo: colorContainerView.topAnchor),
            colorCollectionView.leadingAnchor.constraint(equalTo: colorContainerView.leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: colorContainerView.trailingAnchor),
            colorCollectionView.bottomAnchor.constraint(equalTo: colorContainerView.bottomAnchor)
        ])
    }
    
    // MARK: - Настройка TableView
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrackerOptionCell.self, forCellReuseIdentifier: TrackerOptionCell.identifier)
        tableView.rowHeight = 75
    }
    
    // MARK: - Настройка Emoji CollectionView
    private func setupEmojiCollectionView() {
        emojiCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
    }
    
    // MARK: - Настройка Color CollectionView
    private func setupColorCollectionView() {
        colorCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
    }
    
    // MARK: - Обработчики кнопок
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        guard createButton.isEnabled else { return }
        let newTracker = Tracker(
            id: UUID(),
            name: nameTextField.text ?? "",
            emoji: {
                if let index = selectedEmojiIndex?.item, emojiList.indices.contains(index) {
                    return emojiList[index]
                } else {
                    return "🔥"
                }
            }(),
            color: {
                if let index = selectedColorIndex?.item, colorList.indices.contains(index) {
                    return colorList[index]
                } else {
                    return .systemBlue
                }
            }(),
            schedule: trackerType == .habit ? selectedDaysIndices : nil,
            type: trackerType,
            createdDate: Date(),
            completedDates: []
        )
        onCreateTracker?(newTracker)
        if let presentingVC = self.presentingViewController?.presentingViewController {
            presentingVC.dismiss(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension CreateTrackerDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    private func updateCreateButtonState() {
        let hasText = !(nameTextField.text ?? "").isEmpty
        let hasEmoji = selectedEmojiIndex != nil
        let hasColor = selectedColorIndex != nil
        let isEnabled = hasText && hasEmoji && hasColor

        createButton.isEnabled = isEnabled
        createButton.backgroundColor = isEnabled ? UIColor(named: "Black[day]") : UIColor(named: "Gray")
        createButton.setTitleColor(
            UIColor(named: "White[day]"),
            for: .normal
        )
    }
    
    @objc private func textFieldDidChange() {
        updateCreateButtonState()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackerOptionCell.identifier, for: indexPath) as? TrackerOptionCell else {
            return UITableViewCell()
        }
        
        let title = options[indexPath.row]
        let value = selectedValues[indexPath.row]
        
        cell.configure(with: title, value: value, isLastCell: indexPath.row == options.count - 1)
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if trackerType == .habit, indexPath.row == 1 {
            let scheduleVC = ScheduleViewController()
            scheduleVC.delegate = self
            present(scheduleVC, animated: true)
        }
    }
}

// MARK: - ScheduleViewControllerDelegate
extension CreateTrackerDetailsViewController: ScheduleViewControllerDelegate {
    func didSelectSchedule(_ formattedSchedule: String, chosenDays: [Int]) {
        if let scheduleIndex = options.firstIndex(of: "Расписание") {
            selectedValues[scheduleIndex] = formattedSchedule
            tableView.reloadRows(at: [IndexPath(row: scheduleIndex, section: 0)], with: .none)
        }
        self.selectedDaysIndices = chosenDays
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension CreateTrackerDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == emojiCollectionView ? emojiList.count : colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.identifier, for: indexPath) as? EmojiCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: emojiList[indexPath.item], isSelected: selectedEmojiIndex == indexPath)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: colorList[indexPath.item], isSelected: selectedColorIndex == indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            selectedEmojiIndex = indexPath
        } else {
            selectedColorIndex = indexPath
        }
        collectionView.reloadData()
        updateCreateButtonState()
    }
}
