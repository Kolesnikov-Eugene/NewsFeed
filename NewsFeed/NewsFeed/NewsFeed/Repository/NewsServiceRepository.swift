//
//  NewsServiceRepository.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 18.04.2025.
//

import Foundation

protocol INewsServiceRepository: AnyObject {
    func loadNews(for page: Int) async throws -> [NewsItem]
}

final class NewsServiceRepositoryImpl: INewsServiceRepository {
    
    private let networkClient: INetworkClient
    
    init(
        networkClient: INetworkClient
    ) {
        self.networkClient = networkClient
    }
    
    func loadNews(for page: Int) async throws -> [NewsItem] {
        let newsRequest = NewsFeedRequest(page: page)
        let news = try await networkClient.send(request: newsRequest, type: News.self)
        return news.news
    }
}
