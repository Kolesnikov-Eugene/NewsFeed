//
//  NewsFeedViewModel.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 17.04.2025.
//

import Foundation
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
    
    init(
        newsService: INewsService
    ) {
        self.newsService = newsService
        loadNews()
    }
    
    // MARK: - public methods
    func loadNews() {
        Task {
            do {
                let news = try await newsService.loadNews(for: 1)
                news.forEach { item in
                    newsFeedItems.append(
                        .mainNewsItem(MainNewsItem(
                            title: item.title,
                            description: item.description,
                            imageURL: URL(string: item.titleImageUrl))
                        )
                    )
                }
            } catch {
                print(error)
            }
        }
    }
}
