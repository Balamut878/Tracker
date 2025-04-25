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
            
            let trackersVC = TrackersViewController()
            let trackersNav = UINavigationController(rootViewController: trackersVC)
            trackersNav.tabBarItem = UITabBarItem(
                title: NSLocalizedString("tab_trackers", comment: "Trackers tab title"),
                image: UIImage(named: "TrackersIcon"),
                selectedImage: UIImage(named: "TrackersIconSelected")
            )
            
            let statisticsVC = StatisticsViewController()
            let statisticsNav = UINavigationController(rootViewController: statisticsVC)
            statisticsNav.tabBarItem = UITabBarItem(
                title: NSLocalizedString("tab_statistics", comment: "Statistics tab title"),
                image: UIImage(named: "StatisticsIcon"),
                selectedImage: UIImage(named: "StatisticsIconSelected")
            )
            
            tabBarController.viewControllers = [trackersNav, statisticsNav]
            rootViewController = tabBarController
        } else {
            // Показываем онбординг
            rootViewController = OnboardingViewController()
        }
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(named: "backgroundDynamic")
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "Blue") ?? .blue]
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(named: "Gray") ?? .gray]
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        UITabBar.appearance().tintColor = UIColor(named: "Blue")
        UITabBar.appearance().unselectedItemTintColor = UIColor(named: "Gray")
        // Делаем TabBarController корневым контроллером
        newWindow.rootViewController = rootViewController
        newWindow.makeKeyAndVisible()
        
        // Сохраняем окно в свойство
        self.window = newWindow
    }
}
