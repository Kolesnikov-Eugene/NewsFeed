//
//  MainNewsItem.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 21.04.2025.
//

import Foundation


enum NewsFeedSection: Hashable {
    case main
}

enum NewsFeedItem: Hashable, Equatable {
    case mainNewsItem(MainNewsItem)
}

struct MainNewsItem: Hashable {
    let id = UUID()
    let title: String
    let description: String
    let imageURL: URL?
    let fullNewsURL: URL?
}
