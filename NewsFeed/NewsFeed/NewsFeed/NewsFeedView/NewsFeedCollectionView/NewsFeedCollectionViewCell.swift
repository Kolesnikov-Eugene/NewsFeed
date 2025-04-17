//
//  NewsFeedCollectionViewCell.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 17.04.2025.
//

import UIKit

final class NewsFeedCollectionViewCell: UICollectionViewCell {
    private lazy var newsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cyan
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
    
    func configure(with news: MainNewsItem) {
        newsLabel.text = news.title
    }
    
    private func setupUI() {
        backgroundColor = .red
        addSubview(newsLabel)
        
        NSLayoutConstraint.activate([
            newsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            newsLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
