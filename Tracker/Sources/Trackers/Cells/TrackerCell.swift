//
//  TrackerCell.swift
//  Tracker
//
//  Created by Александр Дудченко on 02.03.2025.
//

import UIKit

/// Класс ячейки для отображения одного трекера
final class TrackerCell: UICollectionViewCell {
    
    // Идентификатор ячейки, чтобы переиспользовать в collectionView
    static let identifier = "TrackerCell"
    
    // MARK: - Вью с цветным фоном
    
    /// Основной фон для блока трекера
    private let eventBackgroundView: UIView = {
        let view = UIView()
        // Скругляем углы
        view.layer.cornerRadius = 16
        // Обрезаем содержимое по скруглённым углам
        view.layer.masksToBounds = true
        // ОтключаемAutoresizingMask
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Эмодзи
    
    /// Маленький лейбл для эмодзи, находится сверху внутри eventBackgroundView
    private let emojiLabel: UILabel = {
        let label = UILabel()
        // Размер шрифта и жирность
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        // Выравнивание по центру
        label.textAlignment = .center
        // Фон — чуть прозрачный белый
        label.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        // Скругляем углы
        label.layer.cornerRadius = 12
        // Обрезаем содержимое
        label.layer.masksToBounds = true
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Название трекера
    
    /// Лейбл с названием трекера (может быть многострочным)
    private let titleLabel: UILabel = {
        let label = UILabel()
        // Шрифт 12, средняя жирность
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        // Белый цвет текста
        label.textColor = .white
        // Разрешаем максимум 2 строки
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Счётчик дней
    
    /// Лейбл, показывающий, сколько дней выполнен трекер
    private let counterLabel: UILabel = {
        let label = UILabel()
        // Шрифт 12, средняя жирность
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        // Текст чёрного цвета
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Кнопка «+»/«галочка»
    
    /// Кнопка, по нажатию которой пользователь отмечает выполнение
    let completeButton: UIButton = {
        // Используем .custom, чтобы не было автоперекраски
        let button = UIButton(type: .custom)
        // Без текста, только иконка
        button.setTitle(nil, for: .normal)
        button.titleLabel?.isHidden = true
        // Иконка пропорциональная
        button.imageView?.contentMode = .scaleAspectFit
        // Фон прозрачный (потом покрасим)
        button.backgroundColor = .clear
        // Скруглённые углы (кнопка круглая)
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Коллбэк нажатия
    
    /// Замыкание, вызываемое при нажатии на кнопку (передадим наверх контроллеру)
    var didTapComplete: (() -> Void)?
    
    // MARK: - Инициализация
    
    /// Стандартный инициализатор ячейки
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        completeButton.addTarget(self, action: #selector(completeTapped), for: .touchUpInside)
    }
    
    /// Нужен при инициализации из storyboard (не используем)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Метод, который вызывается при нажатии на кнопку
    @objc private func completeTapped() {
        didTapComplete?()
    }
    
    // MARK: - Верстка
    
    /// Размещение сабвью внутри ячейки
    private func setupUI() {
        // Добавляем фон
        contentView.addSubview(eventBackgroundView)
        // Эмодзи поверх фона
        eventBackgroundView.addSubview(emojiLabel)
        // Название трекера
        eventBackgroundView.addSubview(titleLabel)
        // Счётчик и кнопку — ниже фона
        contentView.addSubview(counterLabel)
        contentView.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            // **Учитываем отступ сверху 12 (от категории)**
            eventBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            // **Отступ по 16 слева и справа**
            eventBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            eventBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // Эмодзи сверху внутри eventBackgroundView
            emojiLabel.topAnchor.constraint(equalTo: eventBackgroundView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: eventBackgroundView.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
            // Название трекера располагаем под эмодзи (с отступом 8)
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: emojiLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: eventBackgroundView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: eventBackgroundView.trailingAnchor, constant: -8),
            
            // Закрываем нижний край фоновой вью (отступ 8)
            titleLabel.bottomAnchor.constraint(equalTo: eventBackgroundView.bottomAnchor, constant: -8),
            
            // Счётчик дней под eventBackgroundView (тоже учитываем отступ сверху)
            counterLabel.topAnchor.constraint(equalTo: eventBackgroundView.bottomAnchor, constant: 8),
            // Немного смещаем влево на 16 + 8 ?
            // Но, если хотим именно 16 от левого края ячейки:
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16 + 8),
            
            // Кнопка «+» / галочка справа
            completeButton.topAnchor.constraint(equalTo: eventBackgroundView.bottomAnchor, constant: 8),
            // Здесь тоже учитываем отступ 16 справа
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            completeButton.widthAnchor.constraint(equalToConstant: 34),
            completeButton.heightAnchor.constraint(equalToConstant: 34),
            
            // Ограничиваем низ ячейки, чтобы контент влез
            counterLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            completeButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Заполнение ячейки
    
    /// Конфигурируем ячейку под конкретный трекер
    func configure(with tracker: Tracker, isCompleted: Bool, count: Int) {
        // Красим фон
        eventBackgroundView.backgroundColor = tracker.color
        
        // Эмодзи и название
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.name
        
        // Считаем правильное слово (день / дня / дней)
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
        
        // Иконка: галочка или «+»
        let imageName = isCompleted ? "iconCheckmark" : "iconPlus"
        if let icon = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate) {
            completeButton.setImage(icon, for: .normal)
            // Делаем иконку белой
            completeButton.tintColor = .white
        } else {
            completeButton.setImage(nil, for: .normal)
        }
        
        // Красим фон кнопки (круг) тем же цветом
        completeButton.backgroundColor = tracker.color
    }
}
