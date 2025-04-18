//
//  NewsService.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 18.04.2025.
//

import Foundation

protocol INewsService: AnyObject {
    func loadNews(for page: Int) async throws -> [NewsItem]
}

final class NewsService: INewsService {
    
    private let newsServiceRepository: INewsServiceRepository
    
    init(
        newsServiceRepository: INewsServiceRepository
    ) {
        self.newsServiceRepository = newsServiceRepository
    }
    
    func loadNews(for page: Int) async throws -> [NewsItem] {
        let newsItems =  try await newsServiceRepository.loadNews(for: page)
        return newsItems
    }
}
