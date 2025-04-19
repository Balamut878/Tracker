//
//  TrackerCell.swift
//  Tracker
//
//  Created by Александр Дудченко on 02.03.2025.
//

import UIKit

final class TrackerCell: UICollectionViewCell {
    
    // MARK: - Модель трекера (для контекстного меню)
    var tracker: Tracker?
    
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
        label.textColor = UIColor(named: "White[day]")
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Значок «прикреплено»
    private let pinImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .center
        iv.tintColor = .white
        return iv
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
        let interaction = UIContextMenuInteraction(delegate: self)
        eventBackgroundView.addInteraction(interaction)
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
        eventBackgroundView.addSubview(pinImageView)
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
            titleLabel.leadingAnchor.constraint(equalTo: eventBackgroundView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: eventBackgroundView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: eventBackgroundView.bottomAnchor, constant: -12),
            
            pinImageView.topAnchor.constraint(equalTo: eventBackgroundView.topAnchor, constant: 6),
            pinImageView.trailingAnchor.constraint(equalTo: eventBackgroundView.trailingAnchor, constant: -8),
            pinImageView.widthAnchor.constraint(equalToConstant: 24),
            pinImageView.heightAnchor.constraint(equalToConstant: 24),
            
            counterLabel.topAnchor.constraint(equalTo: eventBackgroundView.bottomAnchor, constant: 16),
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            completeButton.centerYAnchor.constraint(equalTo: counterLabel.centerYAnchor),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            completeButton.widthAnchor.constraint(equalToConstant: 34),
            completeButton.heightAnchor.constraint(equalToConstant: 34),
            counterLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        completeButton.layer.cornerRadius = completeButton.bounds.height / 2
    }
    
    // MARK: - Заполнение ячейки
    func configure(with tracker: Tracker, isCompleted: Bool, count: Int) {
        self.tracker = tracker
        
        pinImageView.image = UIImage(named: "iconPin")?.withRenderingMode(.alwaysTemplate)
        pinImageView.isHidden = !tracker.isPinned
        
        eventBackgroundView.backgroundColor = tracker.color
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.name
        
        let dayString: String
        let languageCode = Locale.current.languageCode
        
        if languageCode == "ru" {
            switch count % 10 {
            case 1 where count % 100 != 11:
                dayString = NSLocalizedString("day_singular", comment: "день")
            case 2...4 where !(12...14).contains(count % 100):
                dayString = NSLocalizedString("day_few", comment: "дня")
            default:
                dayString = NSLocalizedString("day_many", comment: "дней")
            }
        } else {
            dayString = count == 1 ? NSLocalizedString("day_singular", comment: "day") : NSLocalizedString("day_many", comment: "days")
        }
        counterLabel.text = "\(count) \(dayString)"
        
        let imageName = isCompleted ? "iconCheckmark" : "iconPlus"
        if let icon = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate) {
            completeButton.setImage(icon, for: .normal)
            completeButton.tintColor = .white
        } else {
            completeButton.setImage(nil, for: .normal)
        }
        
        completeButton.backgroundColor = isCompleted ? UIColor(named: "LightGreen") ?? tracker.color.withAlphaComponent(0.3) : tracker.color
        
        if let imageView = completeButton.imageView {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.deactivate(imageView.constraints)
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 12),
                imageView.heightAnchor.constraint(equalToConstant: 12),
                imageView.centerXAnchor.constraint(equalTo: completeButton.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: completeButton.centerYAnchor)
            ])
        }
    }
}

extension TrackerCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let tracker = tracker else { return nil }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let pinAction = UIAction(title: tracker.isPinned ? "Открепить" : "Закрепить", image: nil) { _ in
                NotificationCenter.default.post(name: Notification.Name("PinTracker"), object: nil, userInfo: ["tracker": tracker])
            }
            
            let editAction = UIAction(title: "Редактировать", image: nil) { _ in
                NotificationCenter.default.post(name: Notification.Name("EditTracker"), object: nil, userInfo: ["tracker": tracker])
            }
            
            let deleteAction = UIAction(title: "Удалить", image: nil, attributes: .destructive) { _ in
                NotificationCenter.default.post(name: Notification.Name("DeleteTrackerConfirmed"), object: nil, userInfo: ["tracker": tracker])
            }
            
            return UIMenu(children: [pinAction, editAction, deleteAction])
        }
    }
}
