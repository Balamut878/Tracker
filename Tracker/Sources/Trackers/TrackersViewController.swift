//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Александр Дудченко on 23.02.2025.
//

import UIKit

class TrackersViewController: UIViewController {

    // MARK: - UI Elements

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
        if let plusImage = UIImage(named: "iconPlus")?.withRenderingMode(.alwaysOriginal) {
            button.setImage(plusImage, for: .normal)
        }
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

        let textField = searchBar.searchTextField
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.clipsToBounds = true

        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 17, weight: .regular)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "Поиск", attributes: placeholderAttributes)

        return searchBar
    }()

    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "iconPlaceholderStar"))
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Фон экрана
        view.backgroundColor = .white

        // Скрываем Navigation Bar
        navigationController?.setNavigationBarHidden(true, animated: false)

        // Настройка UI
        setupUI()
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(plusButton)
        view.addSubview(dateButton)
        view.addSubview(searchBar)
        view.addSubview(placeholderImageView)
        view.addSubview(placeholderLabel)

        plusButton.addTarget(self, action: #selector(addTrackerTapped), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        dateButton.setTitle(currentDateString(), for: .normal)

        setupConstraints()
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            // Кнопка "+"
            plusButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            plusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            plusButton.widthAnchor.constraint(equalToConstant: 42),
            plusButton.heightAnchor.constraint(equalToConstant: 42),

            // Заголовок "Трекеры"
            titleLabel.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: dateButton.leadingAnchor, constant: -8),

            // Кнопка даты
            dateButton.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            dateButton.leadingAnchor.constraint(equalTo: plusButton.trailingAnchor,constant: 234),
            dateButton.widthAnchor.constraint(equalToConstant: 77),
            dateButton.heightAnchor.constraint(equalToConstant: 34),

            // Поисковая строка
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 36),

            // Плейсхолдер (иконка)
                placeholderImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 402),
                placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
                placeholderImageView.heightAnchor.constraint(equalToConstant: 80),

                // Плейсхолдер (текст)
                placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
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

    private func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter.string(from: Date())
    }
}
