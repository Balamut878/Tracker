//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Александр Дудченко on 23.02.2025.
//

import SnapshotTesting
import XCTest
@testable import Tracker

final class TrackerTests: XCTestCase {
    
    // MARK: Light Theme
    
    // MARK: Main screen tests
    
    func testTrackersScreenLight() throws {
        let vc = TrackersViewController()
        
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }
    
    func testTrackersNavBarLight() throws {
        let vc = TrackersViewController()
        let nc = UINavigationController(rootViewController: vc)
        
        assertSnapshots(of: nc, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }
    
    // MARK: Dark Theme

    func testTrackersScreenDark() throws {
        let vc = TrackersViewController()
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }

    func testTrackersNavBarDark() throws {
        let vc = TrackersViewController()
        let nc = UINavigationController(rootViewController: vc)
        assertSnapshots(of: nc, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }
    

    func testTabBarLight() throws {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = UITabBarController()

        let trackersVC = TrackersViewController()
        let navTrackers = UINavigationController(rootViewController: trackersVC)
        navTrackers.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab_trackers", comment: "Trackers tab title"),
            image: UIImage(named: "TrackersIcon"),
            selectedImage: UIImage(named: "TrackersIconSelected")
        )

        let statisticsVC = UIViewController()
        statisticsVC.view.backgroundColor = .white
        statisticsVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab_statistics", comment: "Statistics tab title"),
            image: UIImage(named: "StatisticsIcon"),
            selectedImage: UIImage(named: "StatisticsIconSelected")
        )

        tabBarController.viewControllers = [navTrackers, statisticsVC]
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        assertSnapshots(of: tabBarController, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }

    func testTabBarDark() throws {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = UITabBarController()

        let trackersVC = TrackersViewController()
        let navTrackers = UINavigationController(rootViewController: trackersVC)
        navTrackers.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab_trackers", comment: "Trackers tab title"),
            image: UIImage(named: "TrackersIcon"),
            selectedImage: UIImage(named: "TrackersIconSelected")
        )

        let statisticsVC = UIViewController()
        statisticsVC.view.backgroundColor = .black
        statisticsVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab_statistics", comment: "Statistics tab title"),
            image: UIImage(named: "StatisticsIcon"),
            selectedImage: UIImage(named: "StatisticsIconSelected")
        )

        tabBarController.viewControllers = [navTrackers, statisticsVC]
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        assertSnapshots(of: tabBarController, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }
    
//    func testTrackersCollectionNoCompletedCellLight() throws {
//        let cell = TrackersCollectionViewCell(frame: CGRect(x: 0, y: 0, width: 167, height: 132))
//        let tracker = Tracker(id: UUID(), name: "Test", color: UIColor.white, emoji: "👽", timetable: [.monday], creationDate: Date())
//        cell.configure(tracker: tracker, isCompleted: false, completedDays: 3, date: Date(), isPinned: false)
//
//        assertSnapshots(of: cell, as: [.image(traits: .init(userInterfaceStyle: .light))])
//    }
    
//    func testTrackersCollectionCompletedCellLight() throws {
//        let cell = TrackersCollectionViewCell(frame: CGRect(x: 0, y: 0, width: 167, height: 132))
//        let tracker = Tracker(id: UUID(), name: "Test", color: UIColor.white, emoji: "👽", timetable: [.monday], creationDate: Date())
//        cell.configure(tracker: tracker, isCompleted: true, completedDays: 3, date: Date(), isPinned: false)
//
//        assertSnapshots(of: cell, as: [.image(traits: .init(userInterfaceStyle: .light))])
//    }
}
