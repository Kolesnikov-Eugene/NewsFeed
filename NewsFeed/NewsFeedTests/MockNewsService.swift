//
//  MockNewsService.swift
//  NewsFeedTests
//
//  Created by Eugene Kolesnikov on 21.04.2025.
//

import UIKit
@testable import NewsFeed


final class MockNewsService: INewsService {
    var shouldFail = false
    var mockNews: [NewsItem] = []
    var mockTotal = 20
    
    func loadNews(for page: Int, pageSize: Int) async throws -> ([NewsItem], Int) {
        if shouldFail {
            throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to load"])
        }
        return (mockNews, mockTotal)
    }
}

final class MockImageLoader: ImageLoading {
    func loadImage(from url: URL) async throws -> UIImage {
        UIImage()
    }
}

final class MockCoordinator: INewsFeedCoordinator {
    var didStartNews = false
    
    func start() {
        print("")
    }
    
    func startNews(for url: URL) {
        didStartNews = true
    }
}
