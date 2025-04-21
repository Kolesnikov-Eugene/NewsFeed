//
//  NewsFeedViewModel.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 17.04.2025.
//

import UIKit
import Combine


protocol INewsFeedViewModel: AnyObject {
    var newsFeedItemsPublisher: AnyPublisher<[NewsFeedItem], Never> { get }
    var newsFeedItems: [NewsFeedItem] { get set }
    func loadNews()
    func presentNews(for url: URL)
}

final class NewsFeedViewModel: INewsFeedViewModel {
    var newsFeedItemsPublisher: AnyPublisher<[NewsFeedItem], Never> {
        $newsFeedItems.eraseToAnyPublisher()
    }
    
    @Published var newsFeedItems: [NewsFeedItem] = []
    
    // MARK: - private properties
    private let newsService: INewsService
    private let imageLoader: ImageLoading
    private let coordinator: INewsFeedCoordinator
    
    // MARK: - network call props
    private var currentPage = 1
    private let pageSize = 10
    private var isLoading = false
    private var totalItems = Int.max
    
    
    init(
        newsService: INewsService,
        imageLoader: ImageLoading,
        coordinator: INewsFeedCoordinator
    ) {
        self.newsService = newsService
        self.imageLoader = imageLoader
        self.coordinator = coordinator
        loadNews()
    }
    
    // MARK: - public methods
    func loadNews() {
        guard !isLoading, newsFeedItems.count < totalItems else { return }
        
        Task {
            do {
                let (news, total) = try await newsService.loadNews(for: currentPage, pageSize: pageSize)
                appendNewsToFeed(news)
                totalItems = total
                currentPage += 1
            } catch {
                coordinator.showAlert(with: error.localizedDescription)
            }
            
            isLoading = false
        }
    }
    
    func presentNews(for url: URL) {
        coordinator.startNews(for: url)
    }
    
    private func appendNewsToFeed(_ news: [NewsItem]) {
        let items = news.map {
            NewsFeedItem.mainNewsItem(
                MainNewsItem(
                    title: $0.title,
                    description: $0.description,
                    imageURL: URL(string: $0.titleImageUrl),
                    fullNewsURL: URL(string: $0.fullUrl)
                )
            )
        }
        newsFeedItems.append(contentsOf: items)
    }
}

// MARK: - ImageLoading
extension NewsFeedViewModel: ImageLoading {
    func loadImage(from url: URL) async throws -> UIImage {
        try await imageLoader.loadImage(from: url)
    }
}
