//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Александр Дудченко on 27.02.2025.
//

import UIKit

class CreateTrackerViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
    
    // Заголовок экрана
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Кнопка "Привычка"
    private let habitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Привычка", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Кнопка "Нерегулярное событие"
    private let eventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Нерегулярное событие", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(habitButton)
        view.addSubview(eventButton)
        
        habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        eventButton.addTarget(self, action: #selector(eventButtonTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Создание трекера
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 78),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 114),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -112),
            titleLabel.widthAnchor.constraint(equalToConstant: 149),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.bottomAnchor.constraint(equalTo: habitButton.topAnchor,constant: -295),
            // Кнопка "Привычка"
            habitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 395),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.widthAnchor.constraint(equalToConstant: 335), // Фиксированная ширина
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            // Кнопка "Нерегулярное событие"
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            eventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            eventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            eventButton.widthAnchor.constraint(equalToConstant: 335),
            eventButton.heightAnchor.constraint(equalToConstant: 60),
            
            
        ])
    }
    
    @objc private func habitButtonTapped() {
        let detailsVC = CreateTrackerDetailsViewController()
        detailsVC.modalPresentationStyle = .pageSheet
        present(detailsVC, animated: true, completion: nil)
        print("Выбрана Привычка")
    }
    
    @objc private func eventButtonTapped() {
        print("Выбрано Нерегулярное событие")
    }
}
