//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Александр Дудченко on 06.04.2025.
//

import UIKit

final class OnboardingPageViewController: UIViewController {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let actionButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func configure(with model: OnboardingPage, index: Int, total: Int) {
        imageView.image = model.backgroundImage
        titleLabel.text = model.title
        actionButton.isHidden = !model.showButton
    }
    
    private func setupLayout() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(actionButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        titleLabel.textColor = UIColor(named: "Black[day]") ?? .black
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        
        actionButton.setTitle("Вот это технологии!", for: .normal)
        actionButton.backgroundColor = UIColor(named: "Black[day]")
        actionButton.setTitleColor(.whiteDay, for: .normal)
        actionButton.layer.cornerRadius = 16
        actionButton.contentEdgeInsets = UIEdgeInsets(top: 19, left: 32, bottom: 19, right: 32)
        
        let refHeight: CGFloat = 812.0
        let screenHeight = UIScreen.main.bounds.height
        let scaleFactor = screenHeight / refHeight
        var titleTop: CGFloat = 432 * scaleFactor
        
        if screenHeight <= 667 {
            titleTop = 300
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: titleTop),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -84),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 335),
            actionButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
