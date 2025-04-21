//
//  WebViewController.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 21.04.2025.
//

import UIKit
import Combine
import WebKit

final class WebViewController: UIViewController {
    
    // MARK: - Private properties
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        
        button.image = UIImage(systemName: "chevron.left")
        button.style = .plain
        button.target = self
        button.action = #selector(backButtonTapped)
        button.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.tintColor = UIColor(resource: .fontMain)
        
        return button
    }()
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.progressTintColor = UIColor.black
        view.trackTintColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var viewModel: IWebViewModel
    private var subscribes = [AnyCancellable]()
    
    init(
        viewModel: IWebViewModel,
        url: URL?
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupUI()
        viewModel.viewDidLoad()
        loadWebView(with: url)
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        configureNavBar()
        addSubviews()
        applyConstraints()
    }
    
    private func configureNavBar() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func addSubviews() {
        view.addSubview(webView)
        view.addSubview(progressView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            progressView.topAnchor.constraint(equalTo: webView.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: webView.trailingAnchor)
        ])
    }
    
    private func bind() {
        
        viewModel.progressPublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self = self else { return }
                
                self.setProgressValue(newValue)
                self.viewModel.didUpdateProgressValue(self.webView.estimatedProgress)
                
            }.store(in: &subscribes)
        
        viewModel.progressStatePublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] shouldHide in
                guard let self = self else { return }
                
                if shouldHide {
                    self.setProgressHidden(shouldHide)
                }
            }.store(in: &subscribes)
    }
    
    private func setProgressValue (_ newValue: Float) {
        progressView.progress = newValue
    }
    
    private func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    private func loadWebView(with url: URL?) {
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
