import UIKit

class BaseStudentListViewController: UIViewController, AlertPresentable {
    var shouldReturnToList = false
    // Conforming to the protocol by providing an instance of UIActivityIndicatorView
    var activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showActivityIndicator()
        Task {
            await StudentFetcher.shared.fetchStudents();
        }
    }
}
