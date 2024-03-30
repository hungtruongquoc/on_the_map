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
    
    func fetchStudentsAndDisplay() {
        activityIndicator.startAnimating()
        StudentNetworkHandler.shared.fetchStudents { [weak self] studentList, error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                if let studentList = studentList {
                    // Update UI here to display the students
                    // This might involve calling a method on the view controller
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.studentList = studentList
                    }
                } else if let error = error {
                    self?.showErrorAlert(message: error.localizedDescription)
                }
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
