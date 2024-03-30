//
//  StudentListController.swift
//  On The Map
//
//  Created by Hung Truong on 3/29/24.
//

import Foundation
import UIKit

extension UIViewController {
    func showOverwriteConfirmation() {
        let alertController = UIAlertController(
            title: "Overwrite Location",
            message: "You have already posted a student location. Would you like to overwrite your current location?",
            preferredStyle: .alert
        )

        let overwriteAction = UIAlertAction(title: "Overwrite", style: .default) { _ in
            // Handle the overwrite action
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(overwriteAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
}
