//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Александр Дудченко on 02.03.2025.
//

import UIKit

// MARK: - Протокол делегата
protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectSchedule(_ formattedSchedule: String, chosenDays: [Int])
}

final class ScheduleViewController: UIViewController {
    
    // MARK: - Свойства
    weak var delegate: ScheduleViewControllerDelegate?
    private let daysFull = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    private let daysShort = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    private var selectedDays: Set<Int> = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupTableView()
        setupDoneButton()
    }
    
    // MARK: - Настройка UI
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(tableViewContainer)
        tableViewContainer.addSubview(tableView)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableViewContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableViewContainer.heightAnchor.constraint(equalToConstant: 525),
            tableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Настройка таблицы
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "dayCell")
    }
    
    // MARK: - Настройка кнопки "Готово"
    private func setupDoneButton() {
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
    }
    
    // MARK: - Обработчик кнопки "Готово"
    @objc private func doneTapped() {
        let formattedSchedule = formatSelectedDays()
        let sortedDays = selectedDays.sorted()
        delegate?.didSelectSchedule(formattedSchedule, chosenDays: sortedDays)
        dismiss(animated: true)
    }
    
    private func formatSelectedDays() -> String {
        // Допустим, 0..4 (Пн..Пт) — будни
        let weekdaysSet: Set<Int> = [0,1,2,3,4]
        
        // Если выбран ровно набор [Пн..Пт]:
        if selectedDays == weekdaysSet {
            return "Будние дни"
        }
        
        // Если выбраны все 7 дней:
        if selectedDays.count == 7 {
            return "Каждый день"
        }
        
        // Иначе — короткие названия
        return selectedDays
            .sorted()
            .map { daysShort[$0] }
            .joined(separator: ", ")
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysFull.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "dayCell")
        cell.textLabel?.text = daysFull[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        let switchControl = UISwitch()
        switchControl.isOn = selectedDays.contains(indexPath.row)
        switchControl.tag = indexPath.row
        switchControl.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchControl
        
        if indexPath.row == 0 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.clipsToBounds = true
        } else if indexPath.row == daysFull.count - 1 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.clipsToBounds = true
        } else {
            cell.layer.cornerRadius = 0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        let index = sender.tag
        if sender.isOn {
            selectedDays.insert(index)
        } else {
            selectedDays.remove(index)
        }
    }
}
