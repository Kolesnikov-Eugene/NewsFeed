//
//  NewsService.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 18.04.2025.
//

import Foundation

protocol INewsService: AnyObject {
    func loadNews(for page: Int, pageSize: Int) async throws -> ([NewsItem], Int)
}

final class NewsService: INewsService {
    
    private let newsServiceRepository: INewsServiceRepository
    
    init(
        newsServiceRepository: INewsServiceRepository
    ) {
        self.newsServiceRepository = newsServiceRepository
    }
    
    func loadNews(
        for page: Int,
        pageSize: Int
    ) async throws -> ([NewsItem], Int) {
        let (newsItems, total) =  try await newsServiceRepository.loadNews(for: page, pageSize: pageSize)
        return (newsItems, total)
    }
}
