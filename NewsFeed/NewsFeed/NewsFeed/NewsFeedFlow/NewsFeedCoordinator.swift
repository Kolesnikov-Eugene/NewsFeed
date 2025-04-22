//
//  NewsFeedCoordinator.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 17.04.2025.
//

import UIKit


protocol INewsFeedCoordinator: Coordinator {
    func startNews(for url: URL)
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
        let newsFeedViewController = newsFeedFactory.makeNewsFeedViewController(coordinator: self)
        navigationController.pushViewController(newsFeedViewController, animated: false)
    }
    
    func startNews(for url: URL) {
        let webViewModel = WebViewModel()
        let vc = WebViewController(viewModel: webViewModel, url: url)
        navigationController.pushViewController(vc, animated: true)
    }
}
