//
//  NewsFeedViewController.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 17.04.2025.
//

import UIKit

final class NewsFeedViewController: UIViewController {
    
    // MARK: - public properties
    
    // MARK: - private properties
    private var viewModel: INewsFeedViewModel
    
    // MARK: - init
    init(
        viewModel: INewsFeedViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = "News Feed"
    }
    
    override func loadView() {
        super.loadView()
        self.view = NewsFeedView(frame: .zero, viewModel: viewModel)
    }
    
    // MARK: - public methods
    
    // MARK: - private methods

    
}
