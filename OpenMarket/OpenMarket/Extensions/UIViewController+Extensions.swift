//
//  UIViewController+Extensions.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

extension UIViewController {
    func presentConfirmAlert(message: String) {
        let alertController = UIAlertController(title: AlertSetting.controller,
                                                message: message,
                                                preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: AlertSetting.confirmAction,
                                          style: .default) { [weak self] _ in

            if message == AlertMessage.enrollmentSuccess
                || message == AlertMessage.modificationSuccess {
                self?.dismiss(animated: true)
            } else if message == AlertMessage.deleteSuccess {
                self?.navigationController?.popViewController(animated: true)
            }
        }

        alertController.addAction(confirmAction)

        present(alertController,animated: false)
    }
}


