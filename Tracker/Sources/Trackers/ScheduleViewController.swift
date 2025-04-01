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
        label.textColor = UIColor(named: "Black[day]")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Background[day]")
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
        button.setTitleColor(UIColor(named: "White[day]"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.backgroundColor = UIColor(named: "Black[day]")
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "White[day]")
        setupUI()
        setupTableView()
        setupDoneButton()
    }
    
    // MARK: - Настройка UI
    private func setupUI() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(tableViewContainer)
        contentView.addSubview(doneButton)
        tableViewContainer.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            tableViewContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableViewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tableViewContainer.heightAnchor.constraint(equalToConstant: CGFloat(daysFull.count) * 75),
            
            tableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor),
            
            doneButton.topAnchor.constraint(equalTo: tableViewContainer.bottomAnchor, constant: 47),
            doneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
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
        let weekdaysSet: Set<Int> = [0,1,2,3,4]
        
        if selectedDays == weekdaysSet {
            return "Будние дни"
        }
        
        if selectedDays.count == 7 {
            return "Каждый день"
        }
        
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
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.textLabel?.textColor = UIColor(named: "Black[day]")
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(named: "Background[day]")
        
        let switchControl = UISwitch()
        switchControl.isOn = selectedDays.contains(indexPath.row)
        switchControl.tag = indexPath.row
        switchControl.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        switchControl.onTintColor = UIColor(named: "Blue")
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
