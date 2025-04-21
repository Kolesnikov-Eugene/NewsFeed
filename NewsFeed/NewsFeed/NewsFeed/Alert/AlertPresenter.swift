//
//  AlertController.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 21.04.2025.
//

import UIKit

final class AlertPresenter {

    private init() {}

    static func showError(in viewController: UIViewController, completion: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "Error",
            message: "Try again",
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        }
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }
}
