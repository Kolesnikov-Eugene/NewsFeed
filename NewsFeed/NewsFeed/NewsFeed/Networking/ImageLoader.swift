//
//  ImageLoader.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 18.04.2025.
//

import UIKit

protocol ImageLoading {
    func loadImage(from url: URL) async throws -> UIImage
}

final class ImageLoader: ImageLoading {
    
    private var cache = NSCache<NSURL, UIImage>()
    private let session: URLSession
    
    init(
        session: URLSession = URLSession.shared
    ) {
        self.session = session
    }
    
    func loadImage(from url: URL) async throws -> UIImage {
        if let cached = cache.object(forKey: url as NSURL) {
            return cached
        }
        let (data, _) = try await session.data(from: url)
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        cache.setObject(image, forKey: url as NSURL)
        return image
    }
}
