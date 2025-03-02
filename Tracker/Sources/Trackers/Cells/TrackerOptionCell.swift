//
//  TrackerOptionCell.swift
//  Tracker
//
//  Created by Александр Дудченко on 28.02.2025.
//

import UIKit

final class TrackerOptionCell: UITableViewCell {
    
    static let identifier = "TrackerOptionCell"
    
    // Название опции (Категория, Расписание)
    private let optionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Выбранное значение (например, выбранная категория)
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Стрелочка для навигации
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Разделительная линия
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(optionLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            // Название опции
            optionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            optionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Выбранное значение
            valueLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -8),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Стрелка навигации
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Разделительная линия (только для первой ячейки)
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func configure(with title: String, value: String?, isLastCell: Bool) {
        optionLabel.text = title
        valueLabel.text = value ?? ""
        separatorView.isHidden = isLastCell // Скрываем разделитель у последней ячейки
    }
}
