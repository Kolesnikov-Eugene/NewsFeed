//
//  NewsItem.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 18.04.2025.
//

import Foundation

struct News: Codable {
    let news: [NewsItem]
    let totalCount: Int
}

struct NewsItem: Codable {
    let id: Int
    let title: String
    let description: String
    let publishedDate: String
    let url: String
    let fullUrl: String
    let titleImageUrl: String
    let categoryType: String
}
