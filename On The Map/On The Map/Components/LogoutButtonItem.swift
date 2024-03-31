import UIKit

class LogoutButtonItem: UIBarButtonItem {
    
    // Define a closure type for logout completion
    typealias LogoutCompletion = () -> Void
    
    // Add a property to hold the completion handler
    var onLogoutSuccess: LogoutCompletion?
    
    // Initialize with an action
    // Initializer for programmatic instantiation
    override init() {
        super.init()
        setup()
    }
    
    // Initializer required for storyboard/nib instantiation
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // Private method to perform common setup
    private func setup() {
        // Set the target and action for the button tap event
        self.target = self
        self.action = #selector(logoutTapped)
    }
    
    // Method to be called when the logout button is tapped
    @objc private func logoutTapped() {
        performLogout { [weak self] success in
            if success {
                // Call the completion handler if logout was successful
                self?.onLogoutSuccess?()
            } else {
                // Optionally, handle logout failure here
                print("Logout failed.")
            }
        }
    }
    
    // Performs the actual logout operation
    private func performLogout(completion: @escaping (_ success: Bool) -> Void) {
        Task {
            do {
                _ = try await UdacityNetworkHandler.shared.logout()
                // Assume logout is successful if no error is thrown
                // Clear all data upon successful logout
                clearUserDataAndNavigateToLogin()
            } catch {
                print("Logout error: \(error)")
                completion(false)
            }
        }
    }
    
    private func clearUserData() {
        // Access the app delegate and reset all properties to nil
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.clearData()
    }
    
    private func clearUserDataAndNavigateToLogin() {
        // Clear user data
        clearUserData()
        
        // Navigate to the LoginViewController
        guard let topViewController = UIApplication.topViewController() else { return }
        topViewController.dismiss(animated: true) {
            let loginViewController = LoginViewController() // Instantiate your LoginViewController here
            topViewController.present(loginViewController, animated: true)
        }
    }
}
