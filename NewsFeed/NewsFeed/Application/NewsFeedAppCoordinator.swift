//
//  NewsFeedAppCoordinator.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 17.04.2025.
//

import UIKit

protocol Coordinator {
    func start()
}

final class NewsFeedAppCoordinator: Coordinator {
    // MARK: - private properties
    private let window: UIWindow
    private var childCoordinators: [Coordinator?] = []
    private let navigationController: UINavigationController!
    
    // MARK: - lifecycle
    init(
        window: UIWindow
    ) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    // MARK: - public methods
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        startFlows()
    }
    
    //MARK: - private methods
    private func startFlows() {
        let newsFeedFactory: INewsFeedFactory = NewsFeedFactory()
        let newsFeedCoordinator = NewsFeedCoordinator(
            navigationController: navigationController,
            newsFeedFactory: newsFeedFactory
        )
        childCoordinators.append(newsFeedCoordinator)
        newsFeedCoordinator.start()
    }
}
