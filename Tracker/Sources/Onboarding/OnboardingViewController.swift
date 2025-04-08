//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Александр Дудченко on 06.04.2025.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(title: "Отслеживайте только то, что хотите",
                       backgroundImage: UIImage(named: "onboarding1") ?? UIImage(),
                       showButton: true),
        OnboardingPage(title: "Даже если это\nне литры воды и йога",
                       backgroundImage: UIImage(named: "onboarding2") ?? UIImage(),
                       showButton: true)
    ]
    
    private var currentIndex = 0
    
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll,
                                      navigationOrientation: .horizontal,
                                      options: nil)
        vc.dataSource = self
        vc.delegate = self
        return vc
    }()
    
    private let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        setupPageControl()
        setInitialPage()
    }
    
    private func setupPageViewController() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        pageViewController.didMove(toParent: self)
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .blackDay
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -168),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setInitialPage() {
        guard let firstVC = viewControllerAt(index: 0) else { return }
        pageViewController.setViewControllers([firstVC],
                                              direction: .forward,
                                              animated: true)
    }
    
    private func viewControllerAt(index: Int) -> UIViewController? {
        guard index >= 0 && index < pages.count else { return nil }
        
        let pageVC = OnboardingPageViewController()
        pageVC.configure(
            with: pages[index],
            index: index,
            total: pages.count
        )
        
        if pages[index].showButton {
            pageVC.actionButton.addTarget(self, action: #selector(finishOnboarding), for: .touchUpInside)
        }
        return pageVC
    }
    
    // Завершаем онбординг и показываем основной экран
    @objc private func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            
            let tabBarController = UITabBarController()
            
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
            
            tabBarController.viewControllers = [trackersNav, statisticsNav]
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        }
    }
}

// MARK: - UIPageViewControllerDataSource & Delegate

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        currentIndex -= 1
        return viewControllerAt(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        currentIndex += 1
        return viewControllerAt(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
              let currentVC = pageViewController.viewControllers?.first as? OnboardingPageViewController,
              let index = pages.firstIndex(where: { $0.title == currentVC.titleLabel.text })
        else { return }
        
        currentIndex = index
        pageControl.currentPage = currentIndex
    }
}
