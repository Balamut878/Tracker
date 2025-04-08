//
//  TrackerCategoryViewController.swift
//  Tracker
//
//  Created by Александр Дудченко on 07.04.2025.
//

import UIKit

final class TrackerCategoryViewController: UIViewController {

    // MARK: - UI

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(named: "Black[day]")
        label.textAlignment = .center
        return label
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()

    private let emptyView: UIView = {
        let view = UIView()
        let imageView = UIImageView(image: UIImage(named: "iconPlaceholderStar"))
        let label = UILabel()
        label.text = "Привычки и события можно объединить по смыслу"
        label.textColor = UIColor(named: "Black[day]")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0

        view.addSubview(imageView)
        view.addSubview(label)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),

            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        return view
    }()

    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "Black[day]")
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
    }()

    // MARK: - Properties

    var onCategorySelected: ((TrackerCategory) -> Void)?
    private let viewModel = TrackerCategoryViewModel()
    private var categories: [TrackerCategory] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "White[day]")
        setupLayout()
        setupBindings()
        setupTableView()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCategoryCreated(_:)),
            name: NSNotification.Name("didCreateCategory"),
            object: nil
        )
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onCategoriesChanged?(viewModel.trackerCategoryStore.fetchCategories())
    }

    // MARK: - Setup

    private func setupLayout() {
        [titleLabel, tableView, addButton].forEach { view.addSubview($0) }

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -16),

            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func setupBindings() {
        viewModel.onCategoriesChanged = { [weak self] categories in
            self?.categories = categories
            self?.tableView.reloadData()
            self?.tableView.backgroundView = categories.isEmpty ? self?.emptyView : nil
        }
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    @objc private func addButtonTapped() {
        let newCategoryVC = NewCategoryViewController()
        newCategoryVC.modalPresentationStyle = .automatic
        present(newCategoryVC, animated: true)
    }

    @objc private func handleCategoryCreated(_ notification: Notification) {
        viewModel.onCategoriesChanged = { [weak self] categories in
            self?.categories = categories
            self?.tableView.reloadData()
            self?.tableView.backgroundView = categories.isEmpty ? self?.emptyView : nil
        }
        viewModel.onCategoriesChanged?(viewModel.trackerCategoryStore.fetchCategories())
    }
}

// MARK: - UITableViewDataSource

extension TrackerCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.title
        return cell
    }
}

extension TrackerCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        onCategorySelected?(selectedCategory)
        dismiss(animated: true)
    }
}
