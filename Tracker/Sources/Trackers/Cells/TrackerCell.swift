//
//  TrackerCell.swift
//  Tracker
//
//  Created by Александр Дудченко on 02.03.2025.
//

import UIKit

final class TrackerCell: UICollectionViewCell {
    
    static let identifier = "TrackerCell"
    
    // MARK: - Вью с цветным фоном
    private let eventBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Эмодзи
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Название трекера
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Счётчик дней
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Кнопка «+»/«галочка»
    let completeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(nil, for: .normal)
        button.titleLabel?.isHidden = true
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = .clear
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Коллбэк нажатия
    var didTapComplete: (() -> Void)?
    
    // MARK: - Инициализация
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        completeButton.addTarget(self, action: #selector(completeTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func completeTapped() {
        didTapComplete?()
    }
    
    // MARK: - Верстка
    private func setupUI() {
        contentView.addSubview(eventBackgroundView)
        eventBackgroundView.addSubview(emojiLabel)
        eventBackgroundView.addSubview(titleLabel)
        contentView.addSubview(counterLabel)
        contentView.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            eventBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            eventBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            eventBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emojiLabel.topAnchor.constraint(equalTo: eventBackgroundView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: eventBackgroundView.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: emojiLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: eventBackgroundView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: eventBackgroundView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: eventBackgroundView.bottomAnchor, constant: -8),
            
            counterLabel.topAnchor.constraint(equalTo: eventBackgroundView.bottomAnchor, constant: 8),
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16 + 8),
            
            completeButton.topAnchor.constraint(equalTo: eventBackgroundView.bottomAnchor, constant: 8),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            completeButton.widthAnchor.constraint(equalToConstant: 34),
            completeButton.heightAnchor.constraint(equalToConstant: 34),
            counterLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            completeButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Заполнение ячейки
    func configure(with tracker: Tracker, isCompleted: Bool, count: Int) {
        eventBackgroundView.backgroundColor = tracker.color
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.name
        
        let dayString: String
        switch count % 10 {
        case 1 where count % 100 != 11:
            dayString = "день"
        case 2...4 where !(11...14).contains(count % 100):
            dayString = "дня"
        default:
            dayString = "дней"
        }
        counterLabel.text = "\(count) \(dayString)"
        
        let imageName = isCompleted ? "iconCheckmark" : "iconPlus"
        if let icon = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate) {
            completeButton.setImage(icon, for: .normal)
            completeButton.tintColor = .white
        } else {
            completeButton.setImage(nil, for: .normal)
        }
        
        completeButton.backgroundColor = tracker.color
    }
}
