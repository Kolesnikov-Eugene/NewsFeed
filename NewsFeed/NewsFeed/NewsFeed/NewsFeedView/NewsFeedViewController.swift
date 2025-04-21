//
//  NewsFeedViewController.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 17.04.2025.
//

import UIKit
import Combine

final class NewsFeedViewController: UIViewController {
    
    // MARK: - private properties
    private var viewModel: INewsFeedViewModel
    private var bag = Set<AnyCancellable>()
    
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
        
        viewModel.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        self.view = NewsFeedView(frame: .zero, viewModel: viewModel)
        
        bindToViewModel()
    }
    
    // MARK: - private methods
    private func bindToViewModel() {
        viewModel.loadingError.receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] error in
                guard let self = self else { return }
                AlertPresenter.showError(in: self) {
                    self.viewModel.loadNews()
                }
            }
            .store(in: &bag)
    }
}
