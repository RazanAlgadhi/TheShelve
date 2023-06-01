//
//  UIViewController+Extension.swift
//  BookCatalogue
//
//  Created by pc on 30/05/23.
//

import Foundation
import UIKit
extension UIViewController {
    func showAlert(title: String, message: String, okAction: (() -> Void)?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
}
