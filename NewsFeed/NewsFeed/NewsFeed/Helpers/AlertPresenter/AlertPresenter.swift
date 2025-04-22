//
//  AlertController.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 21.04.2025.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
}

final class AlertPresenter {

    private init() {}

    static func showError(
        in viewController: UIViewController,
        with model: AlertModel,
        completion: @escaping () -> Void
    ) -> Void {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        }
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }
}
