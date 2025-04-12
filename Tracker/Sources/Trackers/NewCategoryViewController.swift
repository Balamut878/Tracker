//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Александр Дудченко on 08.04.2025.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Введите название категории",
            attributes: [
                .foregroundColor: UIColor(named: "Gray") ?? .lightGray,
                .font: UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
        )
        textField.backgroundColor = UIColor(named: "Background[day]")
        textField.layer.cornerRadius = 16
        textField.textAlignment = .left
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor(named: "White[day]"), for: .normal)
        button.backgroundColor = UIColor(named: "Gray")
        button.layer.cornerRadius = 16
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новая категория"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor(named: "Black[day]") ?? .black
        ]
        view.backgroundColor = UIColor(named: "White[day]")
        setupLayout()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        [textField, doneButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func textFieldDidChange() {
        let isTextEmpty = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        doneButton.isEnabled = !isTextEmpty
        doneButton.backgroundColor = isTextEmpty ? UIColor(named: "Gray") : UIColor(named: "Black[day]")
    }
    
    @objc private func doneButtonTapped() {
        guard let title = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !title.isEmpty else { return }
        
        let categoryStore = TrackerCategoryStore()
        let createdCategory = categoryStore.createCategory(title: title)
        
        if let newCategory = categoryStore.makeCategory(from: createdCategory) {
            NotificationCenter.default.post(name: NSNotification.Name("didCreateCategory"),
                                            object: newCategory)
        }
        
        dismiss(animated: true)
    }
}
