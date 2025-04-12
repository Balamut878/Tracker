//
//  TrackerCategoryViewController.swift
//  Tracker
//
//  Created by Александр Дудченко on 07.04.2025.
//

import UIKit

final class TrackerCategoryViewController: UIViewController {
    
    // MARK: - UI Elements
    private let tableContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Background[day]")
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let emptyView: UIView = {
        let view = UIView()
        let imageView = UIImageView(image: UIImage(named: "iconPlaceholderStar"))
        let label = UILabel()
        label.text = "Привычки и события можно\nобъединить по смыслу"
        label.textColor = UIColor(named: "Black[day]")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        return view
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(UIColor(named: "White[day]"), for: .normal)
        button.backgroundColor = UIColor(named: "Black[day]")
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    
    var onCategorySelected: ((TrackerCategory) -> Void)?
    private let viewModel = TrackerCategoryViewModel()
    private var categories: [TrackerCategory] = []
    
    private var selectedIndexPath: IndexPath?
    
    var preselectedCategoryTitle: String?
    
    private var containerHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navTitleLabel = UILabel()
        navTitleLabel.text = "Категория"
        navTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        navTitleLabel.textColor = UIColor(named: "Black[day]")
        navigationItem.titleView = navTitleLabel
        
        view.backgroundColor = UIColor(named: "White[day]")
        
        setupLayout()
        setupBindings()
        setupTableView()
        
        viewModel.onCategoriesChanged?(viewModel.trackerCategoryStore.fetchCategories())
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCategoryCreated(_:)),
            name: NSNotification.Name("didCreateCategory"),
            object: nil
        )
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup Methods
    
    private func setupLayout() {
        view.addSubview(tableContainerView)
        view.addSubview(addButton)
        tableContainerView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.widthAnchor.constraint(equalToConstant: 335),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        containerHeightConstraint = tableContainerView.heightAnchor.constraint(equalToConstant: 10)
        containerHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tableContainerView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.onCategoriesChanged = { [weak self] categories in
            guard let self = self else { return }
            self.categories = categories
            
            if let preselected = self.preselectedCategoryTitle,
               let idx = categories.firstIndex(where: { $0.title == preselected }) {
                self.selectedIndexPath = IndexPath(row: idx, section: 0)
            }
            
            self.tableView.reloadData()
            self.tableView.backgroundView = categories.isEmpty ? self.emptyView : nil
            self.updateContainerHeight()
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrackerCategoryCell.self, forCellReuseIdentifier: TrackerCategoryCell.identifier)
        tableView.rowHeight = 75
    }
    
    private func updateContainerHeight() {
        tableView.layoutIfNeeded()
        let contentHeight = tableView.contentSize.height
        let maxHeight: CGFloat = view.bounds.height - 200
        let neededHeight = min(contentHeight, maxHeight)
        containerHeightConstraint?.constant = neededHeight
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func addButtonTapped() {
        let newCategoryVC = NewCategoryViewController()
        let navController = UINavigationController(rootViewController: newCategoryVC)
        navController.modalPresentationStyle = .automatic
        present(navController, animated: true)
    }
    
    @objc private func handleCategoryCreated(_ notification: Notification) {
        viewModel.onCategoriesChanged = { [weak self] categories in
            guard let self = self else { return }
            self.categories = categories
            self.tableView.reloadData()
            self.tableView.backgroundView = categories.isEmpty ? self.emptyView : nil
            self.updateContainerHeight()
        }
        viewModel.onCategoriesChanged?(viewModel.trackerCategoryStore.fetchCategories())
    }
}

// MARK: - UITableViewDataSource

extension TrackerCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackerCategoryCell.identifier, for: indexPath) as? TrackerCategoryCell else {
            return UITableViewCell()
        }
        
        let category = categories[indexPath.row]
        let isSelected = (indexPath == selectedIndexPath)
        let isFirst = (indexPath.row == 0)
        let isLast = (indexPath.row == categories.count - 1)
        cell.configure(with: category.title, isSelected: isSelected, isFirst: isFirst, isLast: isLast)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TrackerCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        tableView.reloadData()
        let selectedCategory = categories[indexPath.row]
        onCategorySelected?(selectedCategory)
        // dismiss(animated: true)
    }
}
