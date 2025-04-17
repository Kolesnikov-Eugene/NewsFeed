//
//  NewsFeedFactory.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 17.04.2025.
//

import Foundation


protocol INewsFeedFactory: AnyObject {
    func makeNewsFeedViewController() -> NewsFeedViewController
}


final class NewsFeedFactory: INewsFeedFactory {
    func makeNewsFeedViewController() -> NewsFeedViewController {
        let viewModel = NewsFeedViewModel()
        return NewsFeedViewController(viewModel: viewModel)
    }
}
