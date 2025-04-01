//
//  TrackerOptionCell.swift
//  Tracker
//
//  Created by Александр Дудченко on 28.02.2025.
//

import UIKit

final class TrackerOptionCell: UITableViewCell {
    
    static let identifier = "TrackerOptionCell"
    
    // MARK: - Вью с цветным фоном (Категория, Расписание)
    private let optionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor(named: "Black[day]")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Выбранное значение
    private let valueSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(named: "Gray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Стрелочка для навигации
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = UIColor(named: "Gray")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Разделительная линия
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
        contentView.addSubview(valueSubtitleLabel)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            optionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            optionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            
            valueSubtitleLabel.leadingAnchor.constraint(equalTo: optionLabel.leadingAnchor),
            valueSubtitleLabel.topAnchor.constraint(equalTo: optionLabel.bottomAnchor, constant: 2),
            valueSubtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func configure(with title: String, value: String?, isLastCell: Bool) {
        optionLabel.text = title
        
        valueSubtitleLabel.isHidden = value == nil || value?.isEmpty == true
        if let value = value, !value.isEmpty {
            valueSubtitleLabel.text = value
        } else {
            valueSubtitleLabel.text = ""
        }
        
        separatorView.isHidden = isLastCell
    }
}
