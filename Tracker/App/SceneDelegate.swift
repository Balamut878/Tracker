//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Александр Дудченко on 23.02.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        
        // Создаём новое окно
        let newWindow = UIWindow(windowScene: windowScene)
        
        // Инициализируем Tab Bar Controller
        let tabBarController = UITabBarController()
        
        tabBarController.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        tabBarController.tabBar.layer.borderWidth = 0.5
        tabBarController.tabBar.clipsToBounds = true
        
        // Экран "Трекеры"
        let trackersVC = TrackersViewController()
        let trackersNav = UINavigationController(rootViewController: trackersVC)
        trackersNav.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "TrackersIcon"),
            tag: 0
        )
        
        // Экран "Статистика"
        let statisticsVC = StatisticsViewController()
        let statisticsNav = UINavigationController(rootViewController: statisticsVC)
        statisticsNav.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "StatisticsIcon"),
            tag: 1
        )
        
        // Добавляем вкладки в Tab Bar
        tabBarController.viewControllers = [trackersNav, statisticsNav]
        
        // Делаем TabBarController корневым контроллером
        newWindow.rootViewController = tabBarController
        newWindow.makeKeyAndVisible()
        
        // Сохраняем окно в свойство
        self.window = newWindow
    }
}
