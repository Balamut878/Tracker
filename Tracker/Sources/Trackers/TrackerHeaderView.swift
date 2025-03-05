//
//  TrackerHeaderView.swift
//  Tracker
//
//  Created by Александр Дудченко on 02.03.2025.
//

import UIKit

// Финальный (закрытый для наследования) класс, который представляет заголовок секции в CollectionView
final class TrackerHeaderView: UICollectionReusableView {

    // Идентификатор заголовка (используется при регистрации и dequeuing)
    static let identifier = "TrackerHeaderView"

    // Метка (UILabel), которая будет отображать название категории
    private let titleLabel: UILabel = {
        let label = UILabel()
        // Задаём шрифт системный, 19pt, жирный
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        // Чёрный текст
        label.textColor = .black
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var leadingInset: CGFloat = 28
    private var trailingInset: CGFloat = 198

    // Стандартный инициализатор для UICollectionReusableView
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    // Инициализатор через NSCoder (Storyboard) здесь не поддерживается
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Метод, в котором мы добавляем titleLabel и настраиваем констрейнты
    private func setupUI() {
        addSubview(titleLabel)
    }

    func configure(title: String, leadingInset: CGFloat, trailingInset: CGFloat) {
        titleLabel.text = title
        self.leadingInset = leadingInset
        self.trailingInset = trailingInset

        // Удаляем старые констрейнты
        NSLayoutConstraint.deactivate(titleLabel.constraints)

        // Активируем NSLayoutConstraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingInset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailingInset),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
