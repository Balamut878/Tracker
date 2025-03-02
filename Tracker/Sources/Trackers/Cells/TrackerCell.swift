//
//  TrackerCell.swift
//  Tracker
//
//  Created by Александр Дудченко on 02.03.2025.
//

import Foundation
import UIKit

final class TrackerCell: UICollectionViewCell {
    
    static let identifier = "TrackerCell"

    // Название трекера
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Эмодзи
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Фон ячейки с цветом
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Кнопка "+"
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // Счётчик выполнений
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(colorView)
        colorView.addSubview(emojiLabel)
        colorView.addSubview(titleLabel)
        contentView.addSubview(completeButton)
        contentView.addSubview(counterLabel)

        NSLayoutConstraint.activate([
            // Фон
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 90),

            // Эмодзи
            emojiLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 8),
            emojiLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 8),

            // Название
            titleLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -8),

            // Кнопка "+"
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            completeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            completeButton.widthAnchor.constraint(equalToConstant: 34),
            completeButton.heightAnchor.constraint(equalToConstant: 34),

            // Счётчик выполнений
            counterLabel.centerXAnchor.constraint(equalTo: completeButton.centerXAnchor),
            counterLabel.topAnchor.constraint(equalTo: completeButton.bottomAnchor, constant: 4)
        ])
    }

    // Конфигурируем ячейку данными
    func configure(with tracker: Tracker, isCompleted: Bool, count: Int) {
        titleLabel.text = tracker.name
        emojiLabel.text = tracker.emoji
        colorView.backgroundColor = tracker.color
        counterLabel.text = "\(count)"

        let buttonImage = isCompleted ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "plus.circle.fill")
        completeButton.setImage(buttonImage, for: .normal)
    }
}
