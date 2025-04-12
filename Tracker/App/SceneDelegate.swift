//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Александр Дудченко on 23.02.2025.
//

private enum UserDefaultsKeys {
    static let hasSeenOnboarding = "hasSeenOnboarding"
}

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        
        // Создаём новое окно
        let newWindow = UIWindow(windowScene: windowScene)
        
        let rootViewController: UIViewController
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasSeenOnboarding) {
            // Показываем главный экран
            let tabBarController = UITabBarController()
            tabBarController.tabBar.layer.borderColor = UIColor.lightGray.cgColor
            tabBarController.tabBar.layer.borderWidth = 0.5
            tabBarController.tabBar.clipsToBounds = true
            
            let trackersVC = TrackersViewController()
            let trackersNav = UINavigationController(rootViewController: trackersVC)
            trackersNav.tabBarItem = UITabBarItem(
                title: "Трекеры",
                image: UIImage(named: "TrackersIcon"),
                tag: 0
            )
            
            let statisticsVC = StatisticsViewController()
            let statisticsNav = UINavigationController(rootViewController: statisticsVC)
            statisticsNav.tabBarItem = UITabBarItem(
                title: "Статистика",
                image: UIImage(named: "StatisticsIcon"),
                tag: 1
            )
            
            tabBarController.viewControllers = [trackersNav, statisticsNav]
            rootViewController = tabBarController
        } else {
            // Показываем онбординг
            rootViewController = OnboardingViewController()
        }
        
        // Делаем TabBarController корневым контроллером
        newWindow.rootViewController = rootViewController
        newWindow.makeKeyAndVisible()
        
        // Сохраняем окно в свойство
        self.window = newWindow
    }
}
