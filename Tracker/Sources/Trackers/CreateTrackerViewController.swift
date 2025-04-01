//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Александр Дудченко on 27.02.2025.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    
    var onCreateTracker: ((Tracker) -> Void)?
    private var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "White[day]")
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor(named: "Black[day]") ?? .black
        ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        title = "Создание трекера"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        setupUI()
    }
    
    private let habitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Привычка", for: .normal)
        button.setTitleColor(UIColor(named: "White[day]") ?? .white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(named: "Black[day]") ?? .black
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let eventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Нерегулярное событие", for: .normal)
        button.setTitleColor(UIColor(named: "White[day]") ?? .white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(named: "Black[day]") ?? .black
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [habitButton, eventButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        self.stackView = stackView
        
        habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        eventButton.addTarget(self, action: #selector(eventButtonTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func habitButtonTapped() {
        let detailsVC = CreateTrackerDetailsViewController(trackerType: .habit)
        let navController = UINavigationController(rootViewController: detailsVC)
        navController.modalPresentationStyle = .pageSheet
        
        detailsVC.onCreateTracker = { [weak self] newTracker in
            self?.onCreateTracker?(newTracker)
            self?.dismiss(animated: true)
        }
        
        present(navController, animated: true, completion: nil)
        print("Выбрана Привычка")
    }
    
    @objc private func eventButtonTapped() {
        let detailsVC = CreateTrackerDetailsViewController(trackerType: .irregularEvent)
        let navController = UINavigationController(rootViewController: detailsVC)
        navController.modalPresentationStyle = .pageSheet
        
        detailsVC.onCreateTracker = { [weak self] newTracker in
            self?.onCreateTracker?(newTracker)
            self?.dismiss(animated: true)
        }
        
        present(navController, animated: true, completion: nil)
        print("Выбрано Нерегулярное событие")
    }
}
