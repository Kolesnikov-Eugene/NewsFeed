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
}

final class NewsFeedViewModel: INewsFeedViewModel {
    var newsFeedItemsPublisher: AnyPublisher<[NewsFeedItem], Never> {
        $newsFeedItems.eraseToAnyPublisher()
    }
    
    @Published var newsFeedItems: [NewsFeedItem] = [
        .mainNewsItem(MainNewsItem(title: "Super cool title")),
        .mainNewsItem(MainNewsItem(title: "Another super cool title"))
    ]
}
