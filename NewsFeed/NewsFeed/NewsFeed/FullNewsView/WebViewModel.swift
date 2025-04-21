//
//  WebViewModel.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 21.04.2025.
//

import Foundation
import Combine

protocol IWebViewModel: AnyObject {
    var progressValue: Float { get set }
    var progressPublisher: Published<Float>.Publisher { get }
    var shouldHideProgress: Bool { get set }
    var progressStatePublisher: Published<Bool>.Publisher { get }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
}

final class WebViewModel: IWebViewModel {
    // MARK: - Public properties
    @Published var progressValue: Float = 0
    @Published var shouldHideProgress: Bool = false
    var progressPublisher: Published<Float>.Publisher { $progressValue }
    var progressStatePublisher: Published<Bool>.Publisher { $shouldHideProgress }
    
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
