import Foundation
import UIKit

class StudentFetcher {
    weak var viewController: UIViewController?
    var activityIndicator: UIActivityIndicatorView
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        self.activityIndicator = UIActivityIndicatorView(style: .large)
        self.setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        guard let view = viewController?.view else { return }
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func fetchStudentsAndDisplay() async {
        await activityIndicator.startAnimating()
        
        do {
            let studentList = try await StudentNetworkHandler.shared.fetchStudents()
            // Executing UI updates on the main thread using MainActor
            await MainActor.run {
                activityIndicator.stopAnimating()
                // This might involve calling a method on the view controller to update the UI
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.setStudentList(studentList)
                    print(appDelegate.getStudentList())
                }
            }
        } catch {
            // Handling errors and ensuring UI updates are on the main thread
            await MainActor.run {
                activityIndicator.stopAnimating()
                showErrorAlert(message: error.localizedDescription)
            }
        }
    }

    
    private func showErrorAlert(message: String) {
        guard let viewController = viewController else { return }
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true, completion: nil)
    }
}
