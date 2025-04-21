//
//  WebViewModel.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 21.04.2025.
//

import Foundation
import Combine

protocol IWebViewModel: AnyObject {
    var progressPublisher: AnyPublisher<Float, Never> { get }
    var progressStatePublisher: AnyPublisher<Bool, Never> { get }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
}

final class WebViewModel: IWebViewModel {
    // MARK: - Public properties
    @Published var progressValue: Float = 0
    @Published var shouldHideProgress: Bool = false
    var progressPublisher: AnyPublisher<Float, Never>  { $progressValue.eraseToAnyPublisher() }
    var progressStatePublisher: AnyPublisher<Bool, Never> { $shouldHideProgress.eraseToAnyPublisher() }
    
    init() {}
    
    // MARK: - Public methods
    func viewDidLoad() {
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        progressValue = Float(newValue)
        
        shouldHideProgress = shouldHideProgress(for: Float(newValue))
    }
    
    // MARK: - Private methods
    private func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
