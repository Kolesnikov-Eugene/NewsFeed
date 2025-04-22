//
//  NewsFeedViewController.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 17.04.2025.
//

import UIKit
import Combine

final class NewsFeedViewController: UIViewController {
    
    // MARK: - UI
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
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
        
        Task { [weak self] in
            await self?.viewModel.loadNews()
        }
    }
    
    override func loadView() {
        super.loadView()
        self.view = NewsFeedView(frame: .zero, viewModel: viewModel)
        
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        bindToViewModel()
    }
    
    // MARK: - private methods
    private func bindToViewModel() {
        viewModel.loadingError
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] error in
                guard let self = self,
                      let error = error else { return }
                
                let alertModel = AlertModel(title: "Error", message: error)
                AlertPresenter.showError(in: self, with: alertModel) {
                    Task { [weak self] in
                        await self?.viewModel.loadNews()
                    }
                }
            }
            .store(in: &bag)
        
        viewModel.loadingPublisher
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .delay(for: .milliseconds(150), scheduler: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
            }
            .store(in: &bag)
    }
}
