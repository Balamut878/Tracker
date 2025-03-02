//
//  CreateTrackerDetailsViewController.swift
//  Tracker
//
//  Created by Александр Дудченко on 27.02.2025.
//

import UIKit

final class CreateTrackerDetailsViewController: UIViewController {
    
    // MARK: - UI Элементы

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
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
    
    // MARK: - UI Элементы (Добавляем кнопки)
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let options = ["Категория", "Расписание"]
    private var selectedValues: [String?] = [nil, nil]

    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        setupTableView()
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Настройка UI
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(tableViewContainer)
        tableViewContainer.addSubview(tableView)
        view.addSubview(cancelButton)
        view.addSubview(createButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),

            tableViewContainer.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            tableViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableViewContainer.heightAnchor.constraint(equalToConstant: 150),

            tableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),

            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createButton.widthAnchor.constraint(equalToConstant: 166),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Настройка таблицы
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrackerOptionCell.self, forCellReuseIdentifier: TrackerOptionCell.identifier)
        tableView.rowHeight = 75
    }
    
    // MARK: - Обработчики кнопок
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func createButtonTapped() {
        print("Создать трекер")
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension CreateTrackerDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
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
        
        if indexPath.row == 1 { // Нажатие на "Расписание"
            let scheduleVC = ScheduleViewController()
            scheduleVC.delegate = self
            present(scheduleVC, animated: true)
        }
    }
}

// MARK: - ScheduleViewControllerDelegate
extension CreateTrackerDetailsViewController: ScheduleViewControllerDelegate {
    func didSelectSchedule(_ formattedSchedule: String) {
        selectedValues[1] = formattedSchedule
        tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
    }
}
