//
//  NewsFeedViewModelTests.swift
//  NewsFeedTests
//
//  Created by Eugene Kolesnikov on 17.04.2025.
//

import XCTest
@testable import NewsFeed

@MainActor
final class NewsFeedViewModelTests: XCTestCase {
    func testLoadNewsSuccessAppendsItemsAndIncrementsPage() async {
        let mockNews = [
            NewsItem(
                id: 1,
                title: "Test 1",
                description: "desc 1",
                publishedDate: "2025-01-01",
                url: "https://example.com",
                fullUrl: "https://example.com",
                titleImageUrl: "",
                categoryType: ""
            ),
            NewsItem(
                id: 2,
                title: "Test 2",
                description: "desc 2",
                publishedDate: "2025-01-01",
                url: "https://example.com",
                fullUrl: "https://example.com",
                titleImageUrl: "",
                categoryType: ""
            ),
        ]
        
        let service = MockNewsService()
        service.mockNews = mockNews
        
        let viewModel = NewsFeedViewModel(
            newsService: service,
            imageLoader: MockImageLoader(),
            coordinator: MockCoordinator()
        )
        
        await viewModel.loadNews()
        
        let item = viewModel.newsFeedItems[0]
        var text: String = ""
        
        switch item {
        case .mainNewsItem(let newsItem):
            text = newsItem.title
        }
        
        XCTAssertEqual(viewModel.newsFeedItems.count, 2)
        XCTAssertEqual(text, "Test 1")
    }
    
    func testLoadNewsFailureEmitsError() async {
        let service = MockNewsService()
        service.shouldFail = true
        
        let viewModel = NewsFeedViewModel(
            newsService: service,
            imageLoader: MockImageLoader(),
            coordinator: MockCoordinator()
        )
        
        let expectation = XCTestExpectation(description: "Expect error emission")
        var receivedError: String?
        
        let cancellable = viewModel.loadingError
            .dropFirst()
            .sink { error in
                receivedError = error
                expectation.fulfill()
            }

        await viewModel.loadNews()
        await fulfillment(of: [expectation])
        
        XCTAssertEqual(receivedError, "Failed to load")
        cancellable.cancel()
    }
    
    func testPresentNewsTriggersCoordinator() {
        let coordinator = MockCoordinator()
        let viewModel = NewsFeedViewModel(
            newsService: MockNewsService(),
            imageLoader: MockImageLoader(),
            coordinator: coordinator
        )
        
        viewModel.presentNews(for: URL(string: "https://example.com")!)
        
        XCTAssertTrue(coordinator.didStartNews)
    }
}
