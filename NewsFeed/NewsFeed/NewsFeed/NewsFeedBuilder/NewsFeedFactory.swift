//
//  NewsFeedFactory.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 17.04.2025.
//

import Foundation


protocol INewsFeedFactory: AnyObject {
    func makeNewsFeedViewController(coordinator: INewsFeedCoordinator) -> NewsFeedViewController
}


final class NewsFeedFactory: INewsFeedFactory {
    
    func makeNewsFeedViewController(coordinator: INewsFeedCoordinator) -> NewsFeedViewController {
        let networkClient = NetworkClient()
        let imageLoader: ImageLoading = ImageLoader()
        let newsServiceRepository = NewsServiceRepositoryImpl(networkClient: networkClient)
        let newsService = NewsService(newsServiceRepository: newsServiceRepository)
        let viewModel = NewsFeedViewModel(
            newsService: newsService,
            imageLoader: imageLoader,
            coordinator: coordinator
        )
        return NewsFeedViewController(viewModel: viewModel)
    }
}
