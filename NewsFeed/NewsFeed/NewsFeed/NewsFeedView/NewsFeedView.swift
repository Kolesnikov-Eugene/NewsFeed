//
//  NewsFeedView.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 17.04.2025.
//

import UIKit

final class NewsFeedView: UIView {
    
    private let viewModel: INewsFeedViewModel
    private let newsFeedCollectionViewController: UICollectionViewController!
    
    init(
        frame: CGRect,
        viewModel: INewsFeedViewModel
    ) {
        self.viewModel = viewModel
        self.newsFeedCollectionViewController = NewsFeedCollectionViewController(viewModel: viewModel)
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(newsFeedCollectionViewController.collectionView)
        
        if let newsFeedCollectionView = newsFeedCollectionViewController.collectionView {
            NSLayoutConstraint.activate([
                newsFeedCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                newsFeedCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                newsFeedCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                newsFeedCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    }
}
