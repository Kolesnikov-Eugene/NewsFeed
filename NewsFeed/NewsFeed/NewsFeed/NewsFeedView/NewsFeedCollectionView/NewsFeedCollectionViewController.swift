//
//  NewsFeedCollectionViewController.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 17.04.2025.
//

import UIKit
import Combine

private let reuseIdentifier = "NewsFeedCell"
private let iPhoneGroupSize = 1.0 / 5.0
private let iPadGroupSize = 1.0 / 6.0

final class NewsFeedCollectionViewController: UICollectionViewController {
    
    // MARK: - pivate properties
    private let viewModel: INewsFeedViewModel
    private var dataSource: UICollectionViewDiffableDataSource<NewsFeedSection, NewsFeedItem>!
    private var bag = Set<AnyCancellable>()
    
    // MARK: - init
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
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let isRegularWidth = layoutEnvironment.traitCollection.horizontalSizeClass == .regular
            let columns = isRegularWidth ? 2 : 1 // iPad = 2, iPhone = 1
            let cellWidth = columns == 1 ? 1.0 : 0.5 // 1.0 - 1 cell for iPhone, 0.5 - 2 cells in a row for iPad
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(cellWidth),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let groupHeight: NSCollectionLayoutDimension = .fractionalHeight(isRegularWidth ? iPadGroupSize : iPhoneGroupSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: groupHeight
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: columns
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
            return section
        }
    }
    
    // MARK: - private methods
    private func bindToViewModel() {
        viewModel.newsFeedItemsPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newsFeedItems in
                self?.updateSnapshot()
            })
            .store(in: &bag)
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
                    cell.configure(with: newsItem, imageLoader: self.viewModel as? ImageLoading)
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - visibleHeight * 1.5 {
            Task { [weak self] in
                await self?.viewModel.loadNews()
            }
        }
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        var url: URL?
        let item = viewModel.newsFeedItems[indexPath.row]
        switch item {
        case .mainNewsItem(let newsItem):
            url = newsItem.fullNewsURL
        }

        guard let url = url else { return }
        viewModel.presentNews(for: url)
    }
}
