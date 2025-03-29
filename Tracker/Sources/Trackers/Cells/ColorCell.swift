//
//  ColorCell.swift
//  Tracker
//
//  Created by Александр Дудченко on 19.03.2025.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    static let identifier = "ColorCell"
    
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(colorView)
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with color: UIColor, isSelected: Bool) {
        colorView.backgroundColor = color
        contentView.layer.borderWidth = isSelected ? 3 : 0
        contentView.layer.borderColor = isSelected ? color.withAlphaComponent(0.6).cgColor : UIColor.clear.cgColor
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
    }
}
