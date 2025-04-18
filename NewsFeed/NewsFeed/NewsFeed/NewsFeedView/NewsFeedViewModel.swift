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
}

final class NewsFeedViewModel: INewsFeedViewModel {
    var newsFeedItemsPublisher: AnyPublisher<[NewsFeedItem], Never> {
        $newsFeedItems.eraseToAnyPublisher()
    }
    
    @Published var newsFeedItems: [NewsFeedItem] = []
    
    // MARK: - private properties
    private let newsService: INewsService
    private let imageLoader: ImageLoading
    
    init(
        newsService: INewsService,
        imageLoader: ImageLoading
    ) {
        self.newsService = newsService
        self.imageLoader = imageLoader
        loadNews()
    }
    
    // MARK: - public methods
    func loadNews() {
        Task {
            do {
                let news = try await newsService.loadNews(for: 1)
                appendNewsToFeed(news)
            } catch {
                print(error)
            }
        }
    }
    
    private func appendNewsToFeed(_ news: [NewsItem]) {
        news.forEach { item in
            newsFeedItems.append(
                .mainNewsItem(MainNewsItem(
                    title: item.title,
                    description: item.description,
                    imageURL: URL(string: item.titleImageUrl),
                    fullNewsURL: URL(string: item.fullUrl))
                )
            )
        }
    }
}

// MARK: - ImageLoading
extension NewsFeedViewModel: ImageLoading {
    func loadImage(from url: URL) async throws -> UIImage {
        try await imageLoader.loadImage(from: url)
    }
}
