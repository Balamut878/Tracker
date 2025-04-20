//
//  FilterViewController.swift
//  Tracker
//
//  Created by Александр Дудченко on 19.04.2025.
//

// import Foundation
import UIKit

enum TrackerFilterType: CaseIterable {
    case all
    case today
    case completed
    case uncompleted

    var title: String {
        switch self {
        case .all: return "Все трекеры"
        case .today: return "Трекеры на сегодня"
        case .completed: return "Завершённые"
        case .uncompleted: return "Незавершённые"
        }
    }
}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TrackerFilterType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackerCategoryCell.identifier, for: indexPath) as? TrackerCategoryCell else {
            return UITableViewCell()
        }

        let filter = TrackerFilterType.allCases[indexPath.row]
        let isSelected = filter == selectedFilter
        let isFirst = indexPath.row == 0
        let isLast = indexPath.row == TrackerFilterType.allCases.count - 1
        cell.configure(with: filter.title, isSelected: isSelected, isFirst: isFirst, isLast: isLast)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = TrackerFilterType.allCases[indexPath.row]
        onFilterSelected?(selected)
        dismiss(animated: true)
    }
}

final class FilterViewController: UIViewController {
    var onFilterSelected: ((TrackerFilterType) -> Void)?
    private var selectedFilter: TrackerFilterType

    private let navBar = UINavigationBar()
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

    init(selectedFilter: TrackerFilterType) {
        self.selectedFilter = selectedFilter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "White[day]")

        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.backgroundColor = UIColor(named: "White[day]")
        navBar.isTranslucent = false
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        let navTitleLabel = UILabel()
        navTitleLabel.text = "Фильтры"
        navTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        navTitleLabel.textColor = UIColor(named: "Black[day]")
        let navItem = UINavigationItem()
        navItem.titleView = navTitleLabel
        navBar.items = [navItem]
        view.addSubview(navBar)

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        view.addSubview(tableContainerView)
        tableContainerView.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableContainerView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 24),
            tableContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: tableContainerView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 300) // фиксированная высота
        ])

        tableView.rowHeight = 75
        tableView.showsVerticalScrollIndicator = false
        tableView.register(TrackerCategoryCell.self, forCellReuseIdentifier: TrackerCategoryCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}
