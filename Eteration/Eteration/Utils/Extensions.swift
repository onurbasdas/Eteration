//
//  Extensions.swift
//  Eteration
//
//  Created by Onur on 3.02.2024.
//

import UIKit

extension UIViewController {
    func showAlert(title: String = "Alert", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
