//
//  URLHandler.swift
//  On The Map
//
//  Created by Hung Truong on 3/30/24.
//

import Foundation
import UIKit

protocol URLHandler {
    func openStudentURL(_ urlString: String)
}

extension UIViewController: URLHandler {
    func openStudentURL(_ urlString: String) {
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
            presentAlertWithTitle("Invalid URL", message: "The URL provided is not valid or cannot be opened.")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    private func presentAlertWithTitle(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
