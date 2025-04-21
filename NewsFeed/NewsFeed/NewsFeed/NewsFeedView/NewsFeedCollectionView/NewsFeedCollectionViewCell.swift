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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var newsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .fontMain)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.isHidden = traitCollection.horizontalSizeClass == .compact
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var textStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [newsLabel, summaryLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        summaryLabel.text = news.description // Optional: only visible on iPad
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
        backgroundColor = UIColor(resource: .cellBackground)
        layer.cornerRadius = 8
        clipsToBounds = true
        
        contentView.addSubview(newsImageView)
        contentView.addSubview(textStackView)
        
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            newsImageView.widthAnchor.constraint(equalToConstant: 100),
            newsImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            textStackView.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 16),
            textStackView.topAnchor.constraint(equalTo: newsImageView.topAnchor),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
