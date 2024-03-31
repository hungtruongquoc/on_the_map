import Foundation
import UIKit

extension UIViewController {
    func dismissToTab(withIndex tabIndex: Int) {
        self.dismiss(animated: true) { [weak self] in
            self?.tabBarController?.selectedIndex = tabIndex
        }
    }
    
    func showOverwriteConfirmation(returningToTab tabIndex: Int) {
        let alertController = UIAlertController(
            title: "Overwrite Location",
            message: "You have already posted a student location. Would you like to overwrite your current location?",
            preferredStyle: .alert
        )

        let overwriteAction = UIAlertAction(title: "Overwrite", style: .default) { [weak self] _ in
            // Directly use the centralized method to present LocationInputViewController
            self?.presentLocationInputViewController(returningToTab: tabIndex)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(overwriteAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
    
    func presentLocationInputViewController(returningToTab tabIndex: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let locationInputNavController = storyboard.instantiateViewController(withIdentifier: "LocationInputNavigationController") as? UINavigationController,
           let locationInputVC = locationInputNavController.viewControllers.first as? LocationInputViewController {
            
            locationInputVC.onCancel = { [weak self] in
                self?.dismissToTab(withIndex: tabIndex)
            }
            
            locationInputNavController.modalPresentationStyle = .fullScreen
            self.present(locationInputNavController, animated: true, completion: nil)
        }
    }
    
    // New method that accepts a closure returning a Bool
    func showLocationInputScreen(shouldShowOverwriteConfirmation: () -> Bool, returningToTab tabIndex: Int) {
        if shouldShowOverwriteConfirmation() {
            // If the closure returns true, show the overwrite confirmation
            showOverwriteConfirmation(returningToTab: tabIndex)
        } else {
            // If the closure returns false, directly present the LocationInputViewController
            presentLocationInputViewController(returningToTab: tabIndex)
        }
    }
}
