//
//  TrackerHeaderView.swift
//  Tracker
//
//  Created by Александр Дудченко on 02.03.2025.
//

import UIKit

final class TrackerHeaderView: UICollectionReusableView {
    
    static let identifier = "TrackerHeaderView"
    
    // MARK: - Метка
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = UIColor(named: "Black[day]")
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Инициализация
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Верстка
    private func setupUI() {
        addSubview(titleLabel)
    }
    
    func configure(title: String, leadingInset: CGFloat, trailingInset: CGFloat) {
        titleLabel.text = title
        NSLayoutConstraint.deactivate(titleLabel.constraints)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingInset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailingInset),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
