//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Александр Дудченко on 23.02.2025.
//

import UIKit

class TrackersViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Фон экрана
        view.backgroundColor = .white
        
        // Большой заголовок в навигационной шапке
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if var plusImage = UIImage(named: "iconPlus") {
            plusImage = plusImage.withRenderingMode(.alwaysOriginal)
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: plusImage,
                style: .plain,
                target: self,
                action: #selector(addTrackerTapped)
            )
        }
        
        let dateButton = UIButton(type: .system)
        dateButton.setTitle(currentDateString(), for: .normal) // Автоматическая дата
        dateButton.setTitleColor(.black, for: .normal)
        dateButton.backgroundColor = .systemGray5
        dateButton.layer.cornerRadius = 8
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: dateButton)
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()
        
        // Если хочешь настроить поле ввода (скруглённый белый фон):
        if let textField = searchBar.searchTextField as? UITextField {
            textField.backgroundColor = .systemGray6
            textField.layer.cornerRadius = 8
            textField.clipsToBounds = true
        }
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        let placeholderImage = UIImageView(image: UIImage(named: "iconPlaceholderStar"))
        placeholderImage.tintColor = .gray
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Что будем отслеживать?"
        placeholderLabel.textColor = .gray
        placeholderLabel.textAlignment = .center
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(placeholderImage)
        view.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            // Центрируем иконку чуть выше центра
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            // Делаем иконку 80×80
            placeholderImage.widthAnchor.constraint(equalToConstant: 80),
            placeholderImage.heightAnchor.constraint(equalToConstant: 80),
            
            // Текст под иконкой
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func addTrackerTapped() {
        print("Кнопка «+» нажата")
    }
    
    @objc private func dateButtonTapped() {
        print("Кнопка даты нажата")
    }
    
    // MARK: - Helper
    
    /// Возвращает строку текущей даты в формате "dd.MM.yy"
    private func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter.string(from: Date())
    }
}
