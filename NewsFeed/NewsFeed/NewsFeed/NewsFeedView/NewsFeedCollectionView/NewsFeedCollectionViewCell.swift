//
//  NewsFeedCollectionViewCell.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 17.04.2025.
//

import UIKit

final class NewsFeedCollectionViewCell: UICollectionViewCell {
    private lazy var newsImageView: UIImageView = {
        let view = UIImageView()
//        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var newsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cyan
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with news: MainNewsItem, imageLoader: ImageLoading?) {
        newsLabel.text = news.title
        newsImageView.image = nil
        
        guard let url = news.imageURL else { return }
        
        Task { [weak self] in
            do {
                let image = try await imageLoader?.loadImage(from: url)
                await MainActor.run {
                    self?.newsImageView.image = image
                }
            } catch {
                print("Image load failed: \(error)")
            }
        }
    }
    
    private func setupUI() {
        backgroundColor = .red
        contentView.addSubview(newsImageView)
        contentView.addSubview(newsLabel)
        
        // MARK: news image view constraints
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            newsImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            newsImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        // MARK: news label constraints
        NSLayoutConstraint.activate([
            newsLabel.topAnchor.constraint(equalTo: newsImageView.topAnchor),
            newsLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 20),
            newsLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            newsLabel.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor)
        ])
    }
}
