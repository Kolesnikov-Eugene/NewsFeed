//
//  NetworkRequest.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 18.04.2025.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: Encodable? { get }
}

// default values
extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
}

struct NewsFeedRequest: NetworkRequest {
    let page: Int
    let pageSize: Int
    var endpoint: URL? {
        URL(string: "https://webapi.autodoc.ru/api/news/\(page)/\(pageSize)")
    }
    var httpMethod: HttpMethod { .get }
}
