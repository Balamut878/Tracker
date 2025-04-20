//
//  StatisticCell.swift
//  Tracker
//
//  Created by Александр Дудченко on 20.04.2025.
//

import Foundation
import UIKit

final class StatisticCell: UITableViewCell {
    static let identifier = "StatisticCell"

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor(named: "Black[day]")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "Black[day]")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let gradientBorderLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(named: "Color selection 1")?.cgColor ?? UIColor.red.cgColor,
            UIColor(named: "Color selection 9")?.cgColor ?? UIColor.green.cgColor,
            UIColor(named: "Color selection 3")?.cgColor ?? UIColor.blue.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(containerView)
        containerView.addSubview(valueLabel)
        containerView.addSubview(titleLabel)
        // containerView.layer.addSublayer(gradientBorderLayer)
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            valueLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            valueLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),

            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 7),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientBorderLayer.frame = containerView.bounds
        gradientBorderLayer.removeFromSuperlayer()
        containerView.layer.insertSublayer(gradientBorderLayer, at: 0)

        let mask = CAShapeLayer()
        mask.path = UIBezierPath(roundedRect: containerView.bounds.insetBy(dx: 0.5, dy: 0.5), cornerRadius: 16).cgPath
        mask.lineWidth = 1
        mask.strokeColor = UIColor(named: "Black[day]")?.cgColor ?? UIColor.black.cgColor
        mask.fillColor = UIColor.clear.cgColor
        gradientBorderLayer.mask = mask
    }

    func configure(with item: StatisticItem) {
        valueLabel.text = "\(item.value)"
        titleLabel.text = item.title
        setNeedsLayout()
    }
}
