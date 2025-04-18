//
//  NewsFeedCollectionViewController.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 17.04.2025.
//

import UIKit
import Combine

private let reuseIdentifier = "NewsFeedCell"

enum NewsFeedSection: Hashable {
    case main
}

enum NewsFeedItem: Hashable, Equatable {
    case mainNewsItem(MainNewsItem)
}

struct MainNewsItem: Hashable {
    let title: String
    let description: String
    let imageURL: URL?
}

final class NewsFeedCollectionViewController: UICollectionViewController {
    
    private let viewModel: INewsFeedViewModel
    private var dataSource: UICollectionViewDiffableDataSource<NewsFeedSection, NewsFeedItem>!
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        viewModel: INewsFeedViewModel
    ) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: NewsFeedCollectionViewController.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView
            .register(NewsFeedCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        configureCollectionView()
        configureDataSource()
        bindToViewModel()
    }
    
    // MARK: - layout
    static func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.2)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        return layout
    }
    
    // MARK: - private methods
    private func bindToViewModel() {
        viewModel.newsFeedItemsPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newsFeedItems in
                self?.updateSnapshot()
            })
            .store(in: &cancellables)
    }
    
    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: reuseIdentifier,
                    for: indexPath
                ) as? NewsFeedCollectionViewCell else {
                    fatalError("Error creating news feed cell")
                }
                switch itemIdentifier {
                case .mainNewsItem(let newsItem):
                    cell.configure(with: newsItem)
                }
                return cell
            })
        updateSnapshot()
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<NewsFeedSection, NewsFeedItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.newsFeedItems)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
