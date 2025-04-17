//
//  NewsFeedCoordinator.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 17.04.2025.
//

import UIKit


protocol INewsFeedCoordinator: Coordinator {
//    func start()
}

final class NewsFeedCoordinator: INewsFeedCoordinator {
    
    // MARK: - private properties
    private let navigationController: UINavigationController
    private let newsFeedFactory: INewsFeedFactory
    
    //MARK: - init
    init(
        navigationController: UINavigationController,
        newsFeedFactory: INewsFeedFactory
    ) {
        self.navigationController = navigationController
        self.newsFeedFactory = newsFeedFactory
    }
    
    func start() {
        let newsFeedViewController = newsFeedFactory.makeNewsFeedViewController()
        navigationController.pushViewController(newsFeedViewController, animated: false)
    }
}
