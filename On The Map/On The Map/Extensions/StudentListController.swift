//
//  StudentListController.swift
//  On The Map
//
//  Created by Hung Truong on 3/29/24.
//

import Foundation
import UIKit

extension UIViewController {
    // Add a parameter to the function to determine the tab to return to.
    func showOverwriteConfirmation(returningToTab tabIndex: Int) {
        let alertController = UIAlertController(
            title: "Overwrite Location",
            message: "You have already posted a student location. Would you like to overwrite your current location?",
            preferredStyle: .alert
        )

        let overwriteAction = UIAlertAction(title: "Overwrite", style: .default) { [unowned self] _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let locationInputNavController = storyboard.instantiateViewController(withIdentifier: "LocationInputNavigationController") as? UINavigationController,
               let studyingLocationController = locationInputNavController.viewControllers.first as? LocationInputViewController {
                
                // Configure the closure
                studyingLocationController.onCancel = { [weak self] in
                    // Dismiss the navigation controller
                    self?.dismiss(animated: true) {
                        // Use the passed tabIndex to determine which tab to select after dismissal
                        self?.tabBarController?.selectedIndex = tabIndex
                    }
                }
                
                // Present the navigation controller
                locationInputNavController.modalPresentationStyle = .fullScreen
                self.present(locationInputNavController, animated: true, completion: nil)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(overwriteAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
}
