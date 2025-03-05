//
//  TrackerCell.swift
//  Tracker
//
//  Created by Александр Дудченко on 02.03.2025.
//

import UIKit

// Класс кастомной ячейки для CollectionView
final class TrackerCell: UICollectionViewCell {

    // Идентификатор ячейки (используется при регистрации/дDequeuing)
    static let identifier = "TrackerCell"

    // MARK: - Вью с цветным фоном (90 pt)

    // Создаём UIView, который будет играть роль цветного блока.
    // CornerRadius = 16, чтобы блок имел скруглённые углы.
    // Переводим AutoResizingMask в false, чтобы использовать автолейаут.
    private let eventBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Эмодзи

    // UILabel для отображения эмодзи (например, "❤️" или "🐱").
    // font = 16 pt, автолейаут включён (translatesAutoresizingMaskIntoConstraints = false).
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium) // Размер 16pt, Medium
        label.textAlignment = .center
        label.backgroundColor = UIColor(white: 1.0, alpha: 0.3) // Белый цвет с прозрачностью 30%
        label.layer.cornerRadius = 12 // Радиус 12, так как фон 24x24
        label.layer.masksToBounds = true
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Название трекера

    // UILabel для названия трекера. Font size 12, medium, цвет белый.
    // Несколько строк, если название длинное.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Счётчик дней

    // Это UILabel, который покажет, сколько дней (например, "5 дней"),
    // расположен ниже цветного блока, слева.
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Кнопка «+»

    // Кнопка, которая будет внизу справа (ниже блока).
    // setTitle("") убирает текст, чтобы не перекрывать иконку.
    // tintColor = .white, чтобы цвет иконки был белым.
    // cornerRadius 17, значит сама кнопка будет круглой (34×34).
    // translatesAutoresizingMaskIntoConstraints = false для автолейаута.
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 17
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Инициализация

    // Стандартный инициализатор для UICollectionViewCell (через фрейм).
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI() // выносим всю конфигурацию UI в отдельный метод
    }

    // Не используем инициализацию через NSCoder
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Верстка внутренних элементов

    // В этом методе настраиваются subviews и констрейты:
    // добавляем eventBackgroundView, в него - emojiLabel и titleLabel.
    // Затем добавляем counterLabel и completeButton под блоком.
    private func setupUI() {
        // Добавляем "цветной блок" в contentView ячейки
        contentView.addSubview(eventBackgroundView)

        // Внутрь цветного блока добавляем эмодзи и текст
        eventBackgroundView.addSubview(emojiLabel)
        eventBackgroundView.addSubview(titleLabel)

        // Под цветным блоком добавляем счетчик и кнопку
        contentView.addSubview(counterLabel)
        contentView.addSubview(completeButton)

        // Активируем NSLayoutConstraints
        NSLayoutConstraint.activate([
            // Цветной блок по ширине всей ячейки, высота фиксированная (90pt)
            eventBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            eventBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            eventBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            eventBackgroundView.heightAnchor.constraint(equalToConstant: 90),

            // Эмодзи (отступ 8pt сверху и слева внутри блока)
            emojiLabel.widthAnchor.constraint(equalToConstant: 24), // Фон 24x24
                emojiLabel.heightAnchor.constraint(equalToConstant: 24),
                emojiLabel.topAnchor.constraint(equalTo: eventBackgroundView.topAnchor, constant: 12),
                emojiLabel.leadingAnchor.constraint(equalTo: eventBackgroundView.leadingAnchor, constant: 12),
            // Название трекера внизу блока (отступы по бокам 8 и снизу 8)
            titleLabel.leadingAnchor.constraint(equalTo: eventBackgroundView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: eventBackgroundView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: eventBackgroundView.bottomAnchor, constant: -8),

            // Счетчик дней (ниже блока), 8pt отступ сверху
            counterLabel.topAnchor.constraint(equalTo: eventBackgroundView.bottomAnchor, constant: 8),
            // и прижат к левому краю ячейки с отступом 8
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),

            // Кнопка тоже на 8pt ниже блока, но прижата к правому краю
            completeButton.topAnchor.constraint(equalTo: eventBackgroundView.bottomAnchor, constant: 8),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            // Фиксированный размер кнопки 34×34
            completeButton.widthAnchor.constraint(equalToConstant: 34),
            completeButton.heightAnchor.constraint(equalToConstant: 34),

            // Дополнительные ограничения, чтобы нижние элементы не вылезали за границу ячейки
            completeButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            counterLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    // MARK: - Заполнение данными

    // Метод configure вызывается при настройке ячейки
    // Параметры:
    // - tracker: модель трекера (имя, эмодзи, цвет и т.д.)
    // - isCompleted: флаг, выполнен ли трекер
    // - count: количество выполненных дней
    func configure(with tracker: Tracker, isCompleted: Bool, count: Int) {
        // Цвет блока берем из модели
        eventBackgroundView.backgroundColor = tracker.color

        // Устанавливаем эмодзи и название
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.name

        // Счётчик дней. Например, "0 дней" или "1 день" или "5 дня" (упрощённо)
        let dayString = (count == 1) ? "день" : "дня"
        counterLabel.text = "\(count) \(dayString)"

        // Если трекер выполнен, показываем "checkmark", иначе "plus"
        let symbolName = isCompleted ? "checkmark" : "plus"
        let icon = UIImage(systemName: symbolName)
        completeButton.setImage(icon, for: .normal)

        // Фон кнопки делаем таким же, как у блока
        completeButton.backgroundColor = tracker.color
    }
}
